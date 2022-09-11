//
//  MainViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit
import RealmSwift

final class MainViewController: BaseViewController {
    
    private var mainView = MainView()
    
    let repository = UserRepository()
    
    var tasks: Results<UserMemory>! {
        didSet {
            //페이지 바꾸기
            print("\(tasks.count)")
            mainView.pageLabel.text = "\(tasks.count)페이지"
        }
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tasks = repository.fetchMemory()
        
        if tasks.count == 0 {
            mainView.outerView.isHidden = true
            mainView.zeroContentsLabel.isHidden = false
        } else {
            mainView.outerView.isHidden = false
            mainView.zeroContentsLabel.isHidden = true
        }
    }
    
    override func setUpController() {
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(presentAllMemory))
        navigationItem.leftBarButtonItem = menuButton
        navigationController?.navigationBar.tintColor = .diaryColor
        
    }
    
    override func configure() {
        super.configure()
        
        mainView.writingButton.addTarget(self, action: #selector(presentWritingView), for: .touchUpInside)
    }
    
    override func setUpGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushTodayList))
        mainView.outerView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - @objc
    @objc private func presentAllMemory() {
        transition(AllMemoryViewController(), transitionStyle: .presentNavigation)
    }
    
    @objc private func pushTodayList() {
        transition(TodayListViewController(), transitionStyle: .push)
    }
    
    @objc private func presentWritingView() {
        transition(WritingViewController(), transitionStyle: .presentNavigation)
    }
}
