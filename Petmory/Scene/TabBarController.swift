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
    private let calendarViewController = CalendarViewController()
    private let myPetViewController = MyPetViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpAppearance()
        
    }
    
    private func configure() {
        
        let navMain = UINavigationController(rootViewController: mainViewController)
        let navCalendar = UINavigationController(rootViewController: calendarViewController)
        let navMyPet = UINavigationController(rootViewController: myPetViewController)
        
        navMain.tabBarItem.image = UIImage(named: "DiaryTabBarIcon")
        navMain.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        
        navCalendar.tabBarItem.image = UIImage(named: "CalendarTabBarIcon")
        navCalendar.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)

        navMyPet.tabBarItem.image = UIImage(named: "PetTabBarIcon")
        navMyPet.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)

        setViewControllers([navMain, navCalendar, navMyPet], animated: true)

    }
    
    private func setUpAppearance() {
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .diaryColor
        
    }
    
}
