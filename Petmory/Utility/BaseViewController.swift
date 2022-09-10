//
//  BaseViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/07.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpController()
        setUpGesture()
    }
    
    func configure() {}
    
    func setUpController() {}
    
    func setUpGesture() {}
}
