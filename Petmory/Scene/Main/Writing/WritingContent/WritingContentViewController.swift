//
//  WritingContentViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/16.
//

import UIKit

final class WritingContentViewController: BaseViewController {
    
    var mainView = WritingContentView()
    
    var sendContentText: ((String) -> ())?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.textView.becomeFirstResponder()
    }
    override func setUpController() {
        super.setUpController()
        
        //네비게이션 바버튼
        let cancelButton = UIBarButtonItem(title: ButtonTitle.cancel, style: .plain, target: self, action: #selector(cancelWritingContent))
        let doneButton = UIBarButtonItem(title: ButtonTitle.done, style: .plain, target: self, action: #selector(doneWritingContent))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationController?.navigationBar.tintColor = .diaryColor
        
        //네비게이션 컨트롤러
        title = NavigationTitleLabel.contents
    }
    
    //MARK: - @objc
    @objc private func cancelWritingContent() {
        if mainView.textView.text != "" {
            handlerAlert(title: AlertTitle.checkCancel, message: AlertMessage.willNotSave) { _ in
                self.transition(self, transitionStyle: .dismiss)
            }
        } else {
            self.transition(self, transitionStyle: .dismiss)
        }
    }
    @objc private func doneWritingContent() {
        //데이터 전달
        sendContentText?(mainView.textView.text)
        
        transition(self, transitionStyle: .dismiss)
    }
}
