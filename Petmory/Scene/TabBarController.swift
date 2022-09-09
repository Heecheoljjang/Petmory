//
//  TabBarController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/07.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    private let mainViewController = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpAppearance()
    }
    
    private func configure() {
        
        let navMain = UINavigationController(rootViewController: mainViewController)
        mainViewController.tabBarItem.image = UIImage(systemName: "book.fill")
        
        setViewControllers([navMain], animated: true)
    }
    
    private func setUpAppearance() {
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .black
        
    }
    
}
