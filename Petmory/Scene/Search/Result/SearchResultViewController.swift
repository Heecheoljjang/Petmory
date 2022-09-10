//
//  SearchResultViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import RealmSwift

final class SearchResultViewController: BaseViewController {
    
    var mainView = SearchResultView()
    
    var tasks: Results<UserMemory>! {
        didSet {
            mainView.tableView.reloadData()
            print(tasks.count)
        }
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
