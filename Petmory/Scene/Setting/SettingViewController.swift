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
    
    var mainView = SettingView()

    let repository = UserRepository()
    
    let settingList = [SettingList.backupRestore, SettingList.message, SettingList.review]
    let imageList = [SettingListImage.backupImage, SettingListImage.message, SettingListImage.review]
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 16)
        label.text = "설정"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
        
        return version
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = version {
            mainView.versionLabel.text = "버전 \(version)"
        }
    }

    override func setUpController() {
        super.setUpController()
                
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.titleView = titleLabel
        
        //바버튼
        let popButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = popButton
        
    }
    override func configure() {
        super.configure()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    //MARK: - @objc
    @objc private func popView() {
        transition(self, transitionStyle: .pop)
    }
}

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
                noHandlerAlert(title: "등록된 메일 계정을 확인해주세요.", message: "")
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

//MARK: - DocumentPicker
extension SettingViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("취소됨")
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFile = urls.first else {
            noHandlerAlert(title: "선택하신 파일을 찾을 수 없습니다.", message: "")
            return
        }
        
        guard let documentDirectory = documentDirectoryPath() else { return }
        
        let sandboxURL = documentDirectory.appendingPathComponent(selectedFile.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxURL.path) {
            
            let fileName = selectedFile.lastPathComponent
            
            //파일URL
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            do {
                try unZipBackupFile(fileURL: fileURL)
                
                do {
                    let memoryData = try fetchJsonData(fileName: BackupFileName.memory)
                    let calendarData = try fetchJsonData(fileName: BackupFileName.calendar)
                    let petData = try fetchJsonData(fileName: BackupFileName.pet)
                    
                    try repository.localRealm.write {
                        guard let memoryData = try decodeMemoryData(data: memoryData) else { return }
                        guard let calendarData = try decodeCalendarData(data: calendarData) else { return }
                        guard let petListData = try decodePetData(data: petData) else { return }
                        
                        repository.localRealm.add(memoryData)
                        repository.localRealm.add(calendarData)
                        repository.localRealm.add(petListData)
                    }
                    
                    fetchZipFile()
                } catch {
                    throw ErrorType.fetchJsonDataError
                }
                
            } catch {
                noHandlerAlert(title: "압축 해제 실패", message: "")
            }
        } else {
            //앱 내에 없는 경우엔 복사해서 만들어주기
            
            do {
                try FileManager.default.copyItem(at: selectedFile, to: sandboxURL)
                let fileName = selectedFile.lastPathComponent
                
                //파일URL
                let fileURL = documentDirectory.appendingPathComponent(fileName)
                
                do {
                    try unZipBackupFile(fileURL: fileURL)
                    
                    do {
                        let memoryData = try fetchJsonData(fileName: BackupFileName.memory)
                        let calendarData = try fetchJsonData(fileName: BackupFileName.calendar)
                        let petData = try fetchJsonData(fileName: BackupFileName.pet)
                        
                        try repository.localRealm.write {
                            guard let memoryData = try decodeMemoryData(data: memoryData) else { return }
                            guard let calendarData = try decodeCalendarData(data: calendarData) else { return }
                            guard let petListData = try decodePetData(data: petData) else { return }
                            
                            repository.localRealm.add(memoryData)
                            repository.localRealm.add(calendarData)
                            repository.localRealm.add(petListData)
                        }
                        
                        fetchZipFile()
                    } catch {
                        throw ErrorType.fetchJsonDataError
                    }
                    
                } catch {
                    noHandlerAlert(title: "압축 해제 실패", message: "")
                }
            } catch {
                noHandlerAlert(title: "압축 해제 실패", message: "")
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
