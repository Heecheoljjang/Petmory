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
    
    private var mainView = MyPetView()
    
    private let viewModel = MyPetViewModel()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchPet()

    }
    
    private func bind() {
        viewModel.tasks.bind { [weak self] _ in
            self?.mainView.tableView.reloadData()
        }
    }
    
    override func configure() {
        super.configure()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    
    }
    
    override func setUpController() {
        super.setUpController()
        
        navigationController?.navigationBar.tintColor = .diaryColor
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationItem.titleView = mainView.titleLabel
        navigationItem.backButtonTitle = ""

    }
}

extension MyPetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.fetchTaskCount()
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddPetTableViewCell.identifier) as? AddPetTableViewCell else { return UITableViewCell() }
            cell.addButton.addTarget(self, action: #selector(presentRegister(_ :)), for: .touchUpInside)

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPetTableViewCell.identifier) as? MyPetTableViewCell else { return UITableViewCell() }
            if let imageData = viewModel.tasks.value?[indexPath.row].profileImage {
                cell.profileImageView.image = UIImage(data: imageData)
            }
            cell.nameLabel.text = viewModel.tasks.value?[indexPath.row].petName
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            let registerPetVC = RegisterPetViewController()
            registerPetVC.viewModel.currentStatus = CurrentStatus.edit
            registerPetVC.viewModel.task = viewModel.tasks.value?[indexPath.row]
            transition(registerPetVC, transitionStyle: .presentNavigation)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 84
        } else {
            return 100
        }
    }
    //MARK: - @objc
    @objc private func presentRegister(_ sender: UIButton) {
        let registerPetViewController = RegisterPetViewController()
        
        transition(registerPetViewController, transitionStyle: .presentNavigation)
    }
}
