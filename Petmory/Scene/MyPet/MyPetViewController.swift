//
//  MyPetViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import RealmSwift

final class MyPetViewController: BaseViewController {
    
    var mainView = MyPetView()
    
    let repository = UserRepository()
    
    var tasks: Results<UserPet>! {
        didSet {
            print("\(tasks.count)")
            mainView.tableView.reloadData()
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
        
        tasks = repository.fetchPet()
        
        if tasks.count == 0 {
            mainView.noPetLabel.isHidden = false
            mainView.tableView.isHidden = true
        } else {
            mainView.noPetLabel.isHidden = true
            mainView.tableView.isHidden = false
        }
        mainView.tableView.reloadData()
    }
    
    override func configure() {
        super.configure()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    override func setUpController() {
        super.setUpController()
        
        let tempAddButton = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(presentRegisterPetView))
        navigationItem.rightBarButtonItem = tempAddButton
        navigationController?.navigationBar.tintColor = .diaryColor
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        title = "나의 반려동물"
    }
    
    //MARK: - @objc
    @objc private func presentRegisterPetView() {
//        let task = UserPet(petName: "윤희철", birthday: Date(), gender: true, comment: "좋아요", registerDate: Date())
//        repository.addPet(item: task)
//
//        tasks = repository.fetch()
        transition(RegisterPetViewController(), transitionStyle: .presentNavigation)
    }
}

extension MyPetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPetTableViewCell.identifier) as? MyPetTableViewCell else { return UITableViewCell() }
        if let imageData = tasks[indexPath.row].profileImage {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        cell.nameLabel.text = tasks[indexPath.row].petName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
