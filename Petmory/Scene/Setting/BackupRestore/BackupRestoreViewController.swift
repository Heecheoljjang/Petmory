//
//  BackupRestoreViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/27.
//

import UIKit
import RealmSwift
import MessageUI
import JGProgressHUD

final class BackupRestoreViewController: BaseViewController {
    
    var mainView = BackupResotreView()
    
    var backupFileList: [String] = [] {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    let repository = UserRepository()
    
    var memory: Results<UserMemory>!
    
    var calendar: Results<UserCalendar>!
    
    var petList: Results<UserPet>!
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD()
        hud.textLabel.text = "Loading"
        
        return hud
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 16)
        label.text = "백업 및 복구"
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backupFileList = fetchZipFile()
        
        memory = repository.fetchAllMemory()
        calendar = repository.fetchAllCalendar()
        petList = repository.fetchPet()
        
    }
    
    override func configure() {
        super.configure()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.backupButton.addTarget(self, action: #selector(backup), for: .touchUpInside)
        mainView.restoreButton.addTarget(self, action: #selector(restore), for: .touchUpInside)
    }
    
    override func setUpController() {
        super.setUpController()
        
        navigationItem.titleView = titleLabel
        
        //바버튼
        let popButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = popButton
    }
    
    @objc private func popView() {
        transition(self, transitionStyle: .pop)
    }
    
    @objc private func backup() {
        handlerAlert(title: "백업", message: "백업 파일을 만드시겠습니까?") { [weak self] _ in
            
            guard let self = self else { return }
            self.hud.show(in: self.mainView)
            self.makeBackupFile()
        }
    }
    @objc private func restore() {
        
        repository.deleteAllMemory(task: self.memory)
        repository.deleteAllPet(task: self.petList)
        repository.deleteAllCalendar(task: self.calendar)
        
        do {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            self.present(documentPicker, animated: true)
            
        }
    }
}

extension BackupRestoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backupFileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackupRestoreTableViewCell.identifier) as? BackupRestoreTableViewCell else { return UITableViewCell() }
        cell.fileNameLabel.text = backupFileList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActionSheet(fileName: backupFileList[indexPath.row])
    }
}

extension BackupRestoreViewController {
    private func makeBackupFile() {
        do {
            try saveEncodedMemoryToDocument(data: memory, fileName: BackupFileName.memory)
            try saveEncodedCalendarToDocument(data: calendar, fileName: BackupFileName.calendar)
            try saveEncodedPetToDocument(data: petList, fileName: BackupFileName.pet)
            
            let backupFilePath = try zipBackupFile()
            
            hud.dismiss(animated: true)
            showActivityController(backupUrl: backupFilePath)
            
            backupFileList = fetchZipFile()
        } catch {
            hud.dismiss(animated: true)
            noHandlerAlert(title: "압축 실패", message: "다시 확인해주세요.")
        }
    }
}

//MARK: - DocumentPicker
extension BackupRestoreViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("취소됨")
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        handlerAlert(title: "복구", message: "복구가 진행되면 기존의 데이터는 사라집니다. 복구를 진행하시겠습니까?") { [weak self] _ in
            
            guard let self = self else { return }
            if urls.first?.lastPathComponent.split(separator: "_").first! != "Petmory" {
                self.noHandlerAlert(title: "오류", message: "Petmory의 백업 파일이 아닙니다.")
                return
            } else {
                self.hud.show(in: self.mainView)
                
                guard let selectedFile = urls.first else {
                    self.noHandlerAlert(title: "선택하신 파일을 찾을 수 없습니다.", message: "")
                    return
                }
                
                guard let documentDirectory = self.documentDirectoryPath() else { return }
                
                let sandboxURL = documentDirectory.appendingPathComponent(selectedFile.lastPathComponent)
                
                if FileManager.default.fileExists(atPath: sandboxURL.path) {
                    
                    let fileName = selectedFile.lastPathComponent
                    
                    //파일URL
                    let fileURL = documentDirectory.appendingPathComponent(fileName)
                    
                    do {
                        try self.unZipBackupFile(fileURL: fileURL)
                        
                        do {
                            let memoryData = try self.fetchJsonData(fileName: BackupFileName.memory)
                            let calendarData = try self.fetchJsonData(fileName: BackupFileName.calendar)
                            let petData = try self.fetchJsonData(fileName: BackupFileName.pet)
                            
                            try self.repository.localRealm.write {
                                guard let memoryData = try self.decodeMemoryData(data: memoryData) else { return }
                                guard let calendarData = try self.decodeCalendarData(data: calendarData) else { return }
                                guard let petListData = try self.decodePetData(data: petData) else { return }
                                
                                self.repository.localRealm.add(memoryData)
                                self.repository.localRealm.add(calendarData)
                                self.repository.localRealm.add(petListData)
                            }
                            self.hud.dismiss(animated: true)
                            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            let sceneDelegate = windowScene?.delegate as? SceneDelegate
                            
                            let transition = CATransition()
                            transition.type = .fade
                            transition.duration = 0.3
                            sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
                            
                            sceneDelegate?.window?.rootViewController = TabBarController()
                            sceneDelegate?.window?.makeKeyAndVisible()
                        } catch {
                            self.hud.dismiss(animated: true)
                            throw ErrorType.fetchJsonDataError
                        }
                    } catch {
                        self.hud.dismiss(animated: true)
                        self.noHandlerAlert(title: "압축 해제 실패", message: "")
                    }
                } else {
                    //앱 내에 없는 경우엔 복사해서 만들어주기
                    
                    do {
                        try FileManager.default.copyItem(at: selectedFile, to: sandboxURL)
                        let fileName = selectedFile.lastPathComponent
                        
                        //파일URL
                        let fileURL = documentDirectory.appendingPathComponent(fileName)
                        
                        do {
                            try self.unZipBackupFile(fileURL: fileURL)
                            
                            do {
                                let memoryData = try self.fetchJsonData(fileName: BackupFileName.memory)
                                let calendarData = try self.fetchJsonData(fileName: BackupFileName.calendar)
                                let petData = try self.fetchJsonData(fileName: BackupFileName.pet)
                                
                                try self.repository.localRealm.write {
                                    guard let memoryData = try self.decodeMemoryData(data: memoryData) else { return }
                                    guard let calendarData = try self.decodeCalendarData(data: calendarData) else { return }
                                    guard let petListData = try self.decodePetData(data: petData) else { return }
                                    
                                    self.repository.localRealm.add(memoryData)
                                    self.repository.localRealm.add(calendarData)
                                    self.repository.localRealm.add(petListData)
                                }
                                self.hud.dismiss(animated: true)
                                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                                
                                let transition = CATransition()
                                transition.type = .fade
                                transition.duration = 0.3
                                sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
                                
                                sceneDelegate?.window?.rootViewController = TabBarController()
                                sceneDelegate?.window?.makeKeyAndVisible()
                            } catch {
                                self.hud.dismiss(animated: true)
                                throw ErrorType.fetchJsonDataError
                            }
                            
                        } catch {
                            self.hud.dismiss(animated: true)
                            self.noHandlerAlert(title: "압축 해제 실패", message: "")
                        }
                    } catch {
                        self.hud.dismiss(animated: true)
                        self.noHandlerAlert(title: "압축 해제 실패", message: "")
                    }
                }
            }
            
        }
    }
}

//MARK: - MFMailCompose

extension BackupRestoreViewController: UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

//MARK: - ActionSheet
extension BackupRestoreViewController {
    
    private func showActionSheet(fileName: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let restore = UIAlertAction(title: "내보내기", style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            
            let documentPath = self.documentDirectoryPath()
            if let url = documentPath?.appendingPathComponent(fileName) {
                if FileManager.default.fileExists(atPath: url.path) {
                    self.showActivityController(backupUrl: url)
                } else {
                    self.noHandlerAlert(title: "파일을 찾을 수 없습니다.", message: "")
                }
            }
            
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            
            guard let self = self else { return }
            
            self.deleteFileFromDocument(fileName: fileName)
            self.backupFileList = self.fetchZipFile()
            self.mainView.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(restore)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
}
