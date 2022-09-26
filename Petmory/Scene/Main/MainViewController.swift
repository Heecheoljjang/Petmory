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
            mainView.pageLabel.text = "\(tasks.count)페이지"
        }
    }
    
    var petList: Results<UserPet>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //백업 폴더 생성
        createBackupDirectory()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tasks = repository.fetchTodayMemory()
        
        petList = repository.fetchPet()
        
        mainView.dateLabel.text = Date().dateToString(type: .simple)
        
        if tasks.count == 0 {
            mainView.outerView.isHidden = true
            mainView.zeroContentsLabel.isHidden = false
            mainView.tapLabel.isHidden = true
        } else {
            mainView.outerView.isHidden = false
            mainView.zeroContentsLabel.isHidden = true
            mainView.tapLabel.isHidden = false
        }
    }
    
    override func setUpController() {
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(presentAllMemory))
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(presentSetting))
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = settingButton
        navigationController?.navigationBar.tintColor = .diaryColor
        navigationItem.backButtonTitle = ""
        
    }
    
    override func configure() {
        super.configure()
        
//        mainView.dateLabel.text = Date().dateToString(type: .simple)
        mainView.writingButton.addTarget(self, action: #selector(presentWritingView), for: .touchUpInside)
    }
    
    override func setUpGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushTodayList))
        mainView.outerView.addGestureRecognizer(tapGesture)
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
        let todayListViewController = TodayListViewController()
        todayListViewController.navigationTitle = mainView.dateLabel.text!
        transition(todayListViewController, transitionStyle: .presentNavigation)
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
}
