//
//  SettingViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/20.
//
import UIKit
import RealmSwift
import MessageUI

final class SettingViewController: BaseViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Setting>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Setting>
    
    
    private var mainView = SettingView()

    private let repository = UserRepository()
    
    private let settingList = [SettingList.backupRestore, SettingList.message, SettingList.review]
    private let imageList = [SettingListImage.backupImage, SettingListImage.message, SettingListImage.review]

    private var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
        
        return version
    }
    
    var dataSource: DataSource!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = version {
            mainView.versionLabel.text = "버전 \(version)"
        }
        
//        configureHierarchy()
//        configureDataSource()
//        applySnapshot()
    }

    override func setUpController() {
        super.setUpController()
                
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.titleView = mainView.titleLabel
        
        //바버튼
        let popButton = UIBarButtonItem(image: UIImage(systemName: ImageName.chevronLeft), style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = popButton
        
    }
    override func configure() {
        super.configure()

        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
//    override func configure() {
//        super.configure()
//
//        mainView.collectionView.delegate = self
//    }
    
    //MARK: - @objc
    @objc private func popView() {
        transition(self, transitionStyle: .pop)
    }
}

//MARK: - CollectionView
//extension SettingViewController: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(collectionView.cellForItem(at: indexPath)?.frame.height)
//        if indexPath.item == 0 {
//            let backupRestoreVC = BackupRestoreViewController()
//            transition(backupRestoreVC, transitionStyle: .push)
//        } else if indexPath.item == 1 {
//            if !MFMailComposeViewController.canSendMail() {
//                noHandlerAlert(title: AlertTitle.checkEmail, message: "")
//            } else {
//                let composeVC = MFMailComposeViewController()
//                composeVC.mailComposeDelegate = self
//                
//                composeVC.setToRecipients(["kkll135@gmail.com"])
//                composeVC.setSubject("[Petmory]")
//                composeVC.setMessageBody("[문의]", isHTML: false)
//                
//                present(composeVC, animated: true)
//                
//            }
//        } else if indexPath.item == 2 {
//            
//            if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id6443397065?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
//                UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
//            }
//        }
//    }
//}

//extension SettingViewController {
//
//    private func configureHierarchy() {
//        mainView.collectionView.collectionViewLayout = createLayout()
//    }
//
//    private func createLayout() -> UICollectionViewLayout {
//        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
//        configuration.showsSeparators = false
//
//        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
//
//        return layout
//    }
//
//    private func configureDataSource() {
//        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Setting> { cell, indexPath, itemIdentifier in
////            var content = UIListContentConfiguration.valueCell()
////            content.text = itemIdentifier.title
////            content.textProperties.font = UIFont(name: CustomFont.medium, size: 15)!
////            content.imageProperties.tintColor = .black
////            content.image = UIImage(systemName: itemIdentifier.image)
////            content.imageProperties.maximumSize.height = 52
//            var content = cell.defaultContentConfiguration()
//
////            var background = UIBackgroundConfiguration.listPlainCell()
////            background.backgroundInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
//
//            cell.contentConfiguration = content
////            cell.backgroundConfiguration = background
//        }
//        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//
//            return cell
//        })
//    }
//
//    private func applySnapshot() {
//        var snapshot = Snapshot()
//        snapshot.appendSections([0])
//        snapshot.appendItems(Setting.allSettings)
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
//
//}
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier) as? SettingTableViewCell else { return UITableViewCell() }

        cell.titleLabel.text = settingList[indexPath.row]
        cell.cellImage.image = UIImage(systemName: imageList[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            let backupRestoreVC = BackupRestoreViewController()
            transition(backupRestoreVC, transitionStyle: .push)
        } else if indexPath.row == 1 {
            if !MFMailComposeViewController.canSendMail() {
                noHandlerAlert(title: AlertTitle.checkEmail, message: "")
            } else {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self

                composeVC.setToRecipients(["kkll135@gmail.com"])
                composeVC.setSubject("[Petmory]")
                composeVC.setMessageBody("[문의]", isHTML: false)

                present(composeVC, animated: true)

            }
        } else if indexPath.row == 2 {

            if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id6443397065?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
                UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
            }
        }
    }
}



//MARK: - MFMailCompose

extension SettingViewController: UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
