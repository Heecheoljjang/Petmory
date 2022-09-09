//
//  MainViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit

final class MainViewController: BaseViewController {
    
    private var mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpController() {
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(presentAllMemory))
        navigationItem.leftBarButtonItem = menuButton
        navigationController?.navigationBar.tintColor = .diaryColor
    }
    
    //MARK: - @objc
    @objc private func presentAllMemory() {
        transition(AllMemoryViewController(), transitionStyle: .presentNavigation)
    }
}
