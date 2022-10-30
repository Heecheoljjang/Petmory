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
    
    let viewModel = MainViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        
        viewModel.requestAuthorization()

        //현재 년도 구해서 monthList와 더해주기
        viewModel.setCurrentYear()

        //백업용 텍스트파일 지우기
        removeBackupCheckFile()
        
        Analytics.logEvent("MainView_viewDidLoad", parameters: [
            "name": "App Start or Restore",
            "full_text": "fullText",
        ])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchAllMemory()
        
        viewModel.fetchPet()
        
        viewModel.setCountList()

        navigationItem.titleView = mainView.titleViewButton
    }
    
    private func bind() {
        viewModel.currentYear.bind { [weak self] value in
            var attributedTitle = AttributedString(value + "년")
            attributedTitle.font = UIFont(name: CustomFont.medium, size: 16)
            self?.mainView.titleViewButton.configuration?.attributedTitle = attributedTitle
            
            self?.viewModel.setTempList()
        }
        
        viewModel.countList.bind { [weak self] _ in
            self?.mainView.diaryCollectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if viewModel.isFirst.value {
            let indexPath = IndexPath(item: Int(Date().dateToString(type: .onlyMonth))! - 1, section: 0)
            mainView.diaryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            viewModel.isFirst.value = !viewModel.isFirst.value
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

    private func setDatePickerSheet() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let select = UIAlertAction(title: AlertText.select, style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            
            self.viewModel.currentYear.value = self.viewModel.selectedDate.value
            self.viewModel.setCountList()
        }
        let cancel = UIAlertAction(title: AlertText.cancel, style: .cancel)
        let contentViewController = UIViewController()
        contentViewController.view = mainView.pickerView
        contentViewController.preferredContentSize.height = 200
        
        mainView.pickerView.selectRow(Int(Date().dateToString(type: .onlyYear))! - 1990, inComponent: 0, animated: false)
        viewModel.setSelectedDate(date: "\(Int(Date().dateToString(type: .onlyYear))!)")
        
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
        if viewModel.checkPetCount() {
            noHandlerAlert(title: AlertTitle.registerPet, message: "")
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
        return viewModel.monthList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.dateLabel.text = viewModel.tempList.value[indexPath.item]
        cell.pageLabel.text = "\(viewModel.countList.value[indexPath.item]) 페이지"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let monthMemoryVC = MonthMemoryViewController()

        monthMemoryVC.viewModel.monthDate = viewModel.tempList.value[indexPath.item]
        
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
        return viewModel.yearList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(viewModel.yearList[row])년"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedDate.value = "\(viewModel.yearList[row])"
    }
}
