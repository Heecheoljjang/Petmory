//
//  MainViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//
import UIKit
import FirebaseAnalytics
import RxCocoa
import RxSwift

final class MainViewController: BaseViewController {
    
    private var mainView = MainView()
    
    let viewModel = MainViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        
        viewModel.requestAuthorization()

        //현재 년도 구해서 monthList와 더해주기 위해서 현재 연도 구함
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
        
        viewModel.fetchAllMemory() //task바뀜
        
        viewModel.fetchPet() // petList바뀜
        
//        viewModel.setCountList() CountList바뀜 => fetchAllMemory되면 같이 실행됨

//        navigationItem.titleView = mainView.titleViewButton -> 뷰디드로드에서 currentYear바뀌면서 설정됨
    }
    
    private func bind() {
//        viewModel.currentYear.bind { [weak self] value in
//            var attributedTitle = AttributedString(value + "년")
//            attributedTitle.font = UIFont(name: CustomFont.medium, size: 16)
//            self?.mainView.titleViewButton.configuration?.attributedTitle = attributedTitle
//
//            self?.viewModel.setTempList()
//        }
//
//        viewModel.countList.bind { [weak self] _ in
//            self?.mainView.diaryCollectionView.reloadData()
//        }
        
        //MARK: 연도바뀜 -> templist바뀜 -> task바꾼뒤 countList구함
        viewModel.currentYear
            .asDriver(onErrorJustReturn: "error")
            .drive(onNext: { [weak self] year in
                var attributedTitle = AttributedString(year + "년")
                attributedTitle.font = UIFont(name: CustomFont.medium, size: 16)
                self?.mainView.titleViewButton.configuration?.attributedTitle = attributedTitle
                self?.navigationItem.titleView = self?.mainView.titleViewButton
                self?.viewModel.setTempList() //컬렉션뷰 날짜 스트링 만듦
            })
            .disposed(by: disposeBag)
        
        viewModel.tempList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] _ in
                self?.viewModel.fetchAllMemory()
            })
            .disposed(by: disposeBag)
        
        viewModel.tasks
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] _ in
                self?.viewModel.setCountList()
            })
            .disposed(by: disposeBag)

        viewModel.countList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] _ in
                self?.mainView.diaryCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        mainView.writingButton.rx.tap
            .bind { [weak self] _ in
                self?.presentWritingView()
            }
            .disposed(by: disposeBag)
        
        mainView.titleViewButton.rx.tap
            .bind { [weak self] _ in
                self?.presentPickerView() //MARK: sender없어도되는지
            }
            .disposed(by: disposeBag)
        
        //피커뷰 타이틀 설정
        viewModel.yearList
            .map { $0.map{ "\($0)년" } }
            .bind(to: mainView.pickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        mainView.pickerView.rx.itemSelected
            .bind(onNext: { [weak self] row, component in
                guard let self = self else { return }
                
                self.viewModel.selectedDate.accept("\(self.viewModel.yearList.value[row])")
            })
            .disposed(by: disposeBag)
            
        viewModel.tempList
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.diaryCollectionView.rx.items(cellIdentifier: MainCollectionViewCell.identifier, cellType: MainCollectionViewCell.self)) {  (row, element, cell) in
                
                cell.dateLabel.text = element
            }
            .disposed(by: disposeBag)
                
        viewModel.countList
            .do(onNext: { [weak self] _ in
                self?.mainView.diaryCollectionView.delegate = nil
                self?.mainView.diaryCollectionView.dataSource = nil
            })
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.diaryCollectionView.rx.items(cellIdentifier: MainCollectionViewCell.identifier, cellType: MainCollectionViewCell.self)) {  (row, element, cell) in
                
                cell.pageLabel.text = "\(element) 페이지"
            }
            .disposed(by: disposeBag)
        
        mainView.diaryCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                let monthMemoryVC = MonthMemoryViewController()

                guard let monthDate = self?.viewModel.tempList.value[indexPath.item] else { return }
                
                monthMemoryVC.viewModel.monthDate = monthDate
                
                self?.transition(monthMemoryVC, transitionStyle: .push)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if viewModel.isFirst.value {
            let indexPath = viewModel.firstScrollIndex()
            mainView.diaryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            viewModel.setIsNotFirst()
        }
    }
    
    //MARK: - 만약 바버튼도 하면 setupController가 먼저 실행되고 바인딩
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
//        mainView.diaryCollectionView.dataSource = self
        
//        mainView.writingButton.addTarget(self, action: #selector(presentWritingView), for: .touchUpInside)
//        mainView.titleViewButton.addTarget(self, action: #selector(presentPickerView(_ :)), for: .touchUpInside)
        
//        mainView.pickerView.delegate = self
//        mainView.pickerView.dataSource = self
        
    }

    private func setDatePickerSheet() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let select = UIAlertAction(title: AlertText.select, style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            
//            self.viewModel.currentYear.value = self.viewModel.selectedDate.value
            self.viewModel.currentYear.accept(self.viewModel.selectedDate.value)
            
            self.viewModel.setCountList()
        }
        let cancel = UIAlertAction(title: AlertText.cancel, style: .cancel)
        let contentViewController = UIViewController()
        contentViewController.view = mainView.pickerView
        contentViewController.preferredContentSize.height = 200
        
//        mainView.pickerView.selectRow(Int(Date().dateToString(type: .onlyYear))! - 1990, inComponent: 0, animated: false)
        mainView.pickerView.selectRow(viewModel.selectedDate(count: 1990), inComponent: 0, animated: false)
//        viewModel.setSelectedDate(date: "\(Int(Date().dateToString(type: .onlyYear))!)")
        viewModel.setSelectedDate(date: "\(viewModel.selectedDate(count: 0))")
        
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
//
//    @objc private func presentPickerView(_ sender: UIButton) {
//        setDatePickerSheet()
//    }
    
    @objc private func presentPickerView() {
        setDatePickerSheet()
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.monthList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
//        cell.dateLabel.text = viewModel.tempList.value[indexPath.item]
//        cell.pageLabel.text = "\(viewModel.countList.value[indexPath.item]) 페이지"
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let monthMemoryVC = MonthMemoryViewController()
//
//        monthMemoryVC.viewModel.monthDate = viewModel.tempList.value[indexPath.item]
//
//        transition(monthMemoryVC, transitionStyle: .push)
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 260, height: 420)
    }
}

//extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return viewModel.yearList.count
//    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return "\(viewModel.yearList[row])년"
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        viewModel.selectedDate.value = "\(viewModel.yearList[row])"
//    }
//}
