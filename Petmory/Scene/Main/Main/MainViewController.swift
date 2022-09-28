//
//  MainViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//
import UIKit
import RealmSwift

final class MainViewController: BaseViewController {
    
    private var mainView = MainView()
    
    let repository = UserRepository()
    
    var tasks: Results<UserMemory>! {
        didSet {
            //페이지 바꾸기
            //mainView.pageLabel.text = "\(tasks.count)페이지"
        }
    }
    
    var petList: Results<UserPet>!
    
    let monthList = [". 01", ". 02", ". 03", ". 04", ". 05", ". 06", ". 07", ". 08", ". 09", ". 10", ". 11", ". 12"]
    
    var tempList: [String] = []
    
    var currentYear: String = "" {
        didSet {
            titleViewTextField.text = currentYear + "년"
            
            tempList = monthList
            for i in 0..<monthList.count {
                tempList[i] = currentYear + monthList[i]
            }
        }
    }
    
    var countList: [Int] = [] {
        didSet {
            mainView.diaryCollectionView.reloadData()
        }
    }
    
    let yearList = [Int](1900...2200)
    
    let titleViewTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.medium, size: 16)
        textField.textAlignment = .center
        textField.tintColor = .clear
        
        return textField
    }()
    
    let pickerView: UIPickerView = {
        let view = UIPickerView()
        
        return view
    }()
    
    var isFirst = true //컬렉션뷰 스크롤
    
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tasks = repository.fetchAllMemory()
        
        petList = repository.fetchPet()
        
        //현재 년도 구해서 monthList와 더해주기
        currentYear = Date().dateToString(type: .onlyYear)
                
        pickerView.selectRow(Int(Date().dateToString(type: .onlyYear))! - 1900, inComponent: 0, animated: false)
        
        countList = []
        
        tempList.forEach { date in
            countList.append(tasks.filter("memoryDateString CONTAINS[c] '\(date)'").count)
        }
        
        mainView.diaryCollectionView.reloadData()
        
        
        print(#function, tempList)
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

        navigationItem.titleView = titleViewTextField
        
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
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(presentAllMemory))
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(presentSetting))
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = settingButton
        navigationController?.navigationBar.tintColor = .diaryColor
        navigationItem.backButtonTitle = ""
        
        navigationItem.titleView = titleViewTextField
    }
    
    override func configure() {
        super.configure()
        
        mainView.diaryCollectionView.delegate = self
        mainView.diaryCollectionView.dataSource = self
        
        mainView.writingButton.addTarget(self, action: #selector(presentWritingView), for: .touchUpInside)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        titleViewTextField.delegate = self
        titleViewTextField.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .diaryColor
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(tapDoneButton))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tapCancelButton))
        
        toolBar.setItems([cancelButton,flexibleSpace,doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
        
        titleViewTextField.inputAccessoryView = toolBar
    }
    
    //MARK: - @objc
    @objc private func presentAllMemory() {
        
        let petList = repository.fetchPet()
        
        if petList.count == 0 {
            //MARK: Alert 제대로 적용해보기
            noHandlerAlert(title: "반려동물을 등록해주세요!", message: "")
        } else {
            let allMemoryViewController = AllMemoryViewController()
            transition(allMemoryViewController, transitionStyle: .presentNavigation)
        }
    }
    
    @objc private func pushTodayList() {
//        let todayListViewController = TodayListViewController()
//        todayListViewController.navigationTitle = mainView.dateLabel.text!
//        transition(todayListViewController, transitionStyle: .presentNavigation)
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
    
    @objc private func tapDoneButton() {
        let row = pickerView.selectedRow(inComponent: 0)
        pickerView.selectRow(row, inComponent: 0, animated: false)
        titleViewTextField.text = "\(yearList[row])년"
        titleViewTextField.resignFirstResponder()
    }
    
    @objc private func tapCancelButton() {
        titleViewTextField.resignFirstResponder()
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
        currentYear = "\(yearList[row])"
        
        navigationItem.titleView = titleViewTextField

        countList = []
        
        tempList.forEach { date in
            countList.append(tasks.filter("memoryDateString CONTAINS[c] '\(date)'").count)
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        titleViewTextField.isUserInteractionEnabled = false
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        titleViewTextField.isUserInteractionEnabled = true
    }
}
