//
//  MainViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//
import UIKit
import RealmSwift
import FirebaseAnalytics

final class MainViewController: BaseViewController {
    
    private var mainView = MainView()
    
    private let repository = UserRepository()
    
    private var tasks: Results<UserMemory>!
    
    private var petList: Results<UserPet>!
    
    private let monthList = [". 01", ". 02", ". 03", ". 04", ". 05", ". 06", ". 07", ". 08", ". 09", ". 10", ". 11", ". 12"]
    
    private var tempList: [String] = []
    
    private var selectedDate = ""
    
    private var currentYear: String = "" {
        didSet {
            var attributedTitle = AttributedString(currentYear + "년")
            attributedTitle.font = UIFont(name: CustomFont.medium, size: 16)
            mainView.titleViewButton.configuration?.attributedTitle = attributedTitle
            
            tempList = monthList
            for i in 0..<monthList.count {
                tempList[i] = currentYear + monthList[i]
            }
        }
    }
    
    private var countList: [Int] = [] {
        didSet {
            mainView.diaryCollectionView.reloadData()
        }
    }
    
    private let yearList = [Int](1990...2050)
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private var isFirst = true //컬렉션뷰 스크롤
    
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        requestAuthorization()
        
        tasks = repository.fetchAllMemory()
        
        petList = repository.fetchPet()
        
        //현재 년도 구해서 monthList와 더해주기
        currentYear = Date().dateToString(type: .onlyYear)
                        
        countList = []
        
        tempList.forEach { date in
            countList.append(tasks.filter("memoryDateString CONTAINS[c] '\(date)'").count)
        }
                
        //백업용 텍스트파일 지우기
        removeBackupCheckFile()
        
        Analytics.logEvent("MainView_viewDidLoad", parameters: [
            "name": "App Start or Restore",
            "full_text": "fullText",
        ])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tasks = repository.fetchAllMemory()
        
        petList = repository.fetchPet()
        
        countList = []
        
        tempList.forEach { date in
            countList.append(tasks.filter("memoryDateString CONTAINS[c] '\(date)'").count)
        }
        
        mainView.diaryCollectionView.reloadData()

        navigationItem.titleView = mainView.titleViewButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirst == true {
            let indexPath = IndexPath(item: Int(Date().dateToString(type: .onlyMonth))! - 1, section: 0)
            mainView.diaryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            isFirst = false
        }
    }
    
    override func setUpController() {
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: ImageName.menu), style: .plain, target: self, action: #selector(presentAllMemory))
        let settingButton = UIBarButtonItem(image: UIImage(systemName: ImageName.gear), style: .plain, target: self, action: #selector(presentSetting))
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = settingButton
        navigationController?.navigationBar.tintColor = .diaryColor
        navigationItem.backButtonTitle = ""
        
    }
    
    override func configure() {
        super.configure()
        
        mainView.diaryCollectionView.delegate = self
        mainView.diaryCollectionView.dataSource = self
        
        mainView.writingButton.addTarget(self, action: #selector(presentWritingView), for: .touchUpInside)
        mainView.titleViewButton.addTarget(self, action: #selector(presentPickerView(_ :)), for: .touchUpInside)
        
        mainView.pickerView.delegate = self
        mainView.pickerView.dataSource = self
        
    }
    private func requestAuthorization() {
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in

            if success == true {
                
            } else {
                
            }
        }
    }
    
    private func setDatePickerSheet() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let select = UIAlertAction(title: "선택", style: .default) { [weak self] _ in
            
            guard let self = self else { return }

            self.currentYear = self.selectedDate
            self.countList = []
            
            self.tempList.forEach { date in
                self.countList.append(self.tasks.filter("memoryDateString CONTAINS[c] '\(date)'").count)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let contentViewController = UIViewController()
        contentViewController.view = mainView.pickerView
        contentViewController.preferredContentSize.height = 200
        
        mainView.pickerView.selectRow(Int(Date().dateToString(type: .onlyYear))! - 1990, inComponent: 0, animated: false)
        selectedDate = "\(Int(Date().dateToString(type: .onlyYear))!)"
        
        alert.setValue(contentViewController, forKey: "contentViewController")
        alert.addAction(select)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    //MARK: - @objc
    @objc private func presentAllMemory() {
                
        let allMemoryViewController = AllMemoryViewController()
        transition(allMemoryViewController, transitionStyle: .presentNavigation)
        
    }

    @objc private func presentWritingView() {
        let writingViewController = WritingViewController()
        if petList.count == 0 {
            //MARK: 펫부터 등록하라고 alert띄우고 펫 등록화면 띄우는 방식으로
            noHandlerAlert(title: "반려동물을 등록해주세요!", message: "")
        } else {
            transition(writingViewController, transitionStyle: .presentNavigation)
        }
    }
    @objc private func presentSetting() {
        let settingViewController = SettingViewController()
        transition(settingViewController, transitionStyle: .push)
    }

    @objc private func presentPickerView(_ sender: UIButton) {
        setDatePickerSheet()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.dateLabel.text = tempList[indexPath.item]
        cell.pageLabel.text = "\(countList[indexPath.item]) 페이지"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let monthMemoryVC = MonthMemoryViewController()
        monthMemoryVC.monthDate = tempList[indexPath.item]
        
        transition(monthMemoryVC, transitionStyle: .push)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 260, height: 420)
    }
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(yearList[row])년"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDate = "\(yearList[row])"
    }
}
