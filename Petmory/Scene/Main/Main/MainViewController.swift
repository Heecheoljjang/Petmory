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
        viewModel.setCurrentYear()
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
    }
    
    private func bind() {
        //MARK: 연도바뀜 -> templist바뀜 -> task바꾼뒤 countList구함
        viewModel.currentYear
            .asDriver(onErrorJustReturn: "error")
            .drive(onNext: { [weak self] year in
                var attributedTitle = AttributedString(year + "년")
                attributedTitle.font = UIFont(name: CustomFont.medium, size: 16)
                self?.mainView.titleViewButton.configuration?.attributedTitle = attributedTitle
                self?.navigationItem.titleView = self?.mainView.titleViewButton
                self?.viewModel.setTempList()
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
                self?.presentPickerView()
            }
            .disposed(by: disposeBag)
        
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

        //MARK: 해결 오래걸림
        viewModel.tempAndCount
            .asDriver(onErrorJustReturn: [] )
            .drive(mainView.diaryCollectionView.rx.items(cellIdentifier: MainCollectionViewCell.identifier, cellType: MainCollectionViewCell.self)) { (row, element, cell) in
                cell.dateLabel.text = element.0
                cell.pageLabel.text = "\(element.1) 페이지"
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
    }

    private func setDatePickerSheet() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let select = UIAlertAction(title: AlertText.select, style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            
            self.viewModel.currentYear.accept(self.viewModel.selectedDate.value)
            self.viewModel.setCountList()
        }
        let cancel = UIAlertAction(title: AlertText.cancel, style: .cancel)
        let contentViewController = UIViewController()
        contentViewController.view = mainView.pickerView
        contentViewController.preferredContentSize.height = 200

        mainView.pickerView.selectRow(viewModel.selectedDate(count: 1990), inComponent: 0, animated: false)
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

    @objc private func presentPickerView() {
        setDatePickerSheet()
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 260, height: 420)
    }
}
