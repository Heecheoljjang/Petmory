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
import FirebaseAnalytics

final class BackupRestoreViewController: BaseViewController {
    
    private var mainView = BackupResotreView()
    
    private var backupFileList: [String] = [] {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    private let repository = UserRepository()
    
    private var memory: Results<UserMemory>!
    
    private var calendar: Results<UserCalendar>!
    
    private var petList: Results<UserPet>!
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD()
        hud.textLabel.text = "Loading"
        
        return hud
    }()
    
    
    let notificationCenter = UNUserNotificationCenter.current()
    
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
        
        navigationItem.titleView = mainView.titleLabel
        
        //바버튼
        let popButton = UIBarButtonItem(image: UIImage(systemName: ImageName.chevronLeft), style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = popButton
    }
    
    @objc private func popView() {
        transition(self, transitionStyle: .pop)
    }
    
    @objc private func backup() {
        hud.show(in: mainView)
        backupHandlerAlert(title: AlertTitle.backup, message: AlertMessage.makeBackup) { [weak self] _ in
            
            guard let self = self else { return }
            self.makeBackupFile()
        }
    }
    @objc private func restore() {
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
        
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
        Analytics.logEvent("Make_Backup_File", parameters: [
            "name": "Make Backup File",
        ])
        do {
            try saveEncodedMemoryToDocument(data: memory, fileName: BackupFileName.memory)
            try saveEncodedCalendarToDocument(data: calendar, fileName: BackupFileName.calendar)
            try saveEncodedPetToDocument(data: petList, fileName: BackupFileName.pet)
            
            //백업 체크 파일 생성
            createBackupCheckFile()
            
            let backupFilePath = try zipBackupFile()
            
            hud.dismiss(animated: true)
            showActivityController(backupUrl: backupFilePath)
            
            backupFileList = fetchZipFile()
            
            removeBackupCheckFile()
        } catch {
            hud.dismiss(animated: true)
            noHandlerAlert(title: AlertTitle.failZip, message: AlertMessage.checkFile)
        }
    }
    private func backupHandlerAlert(title: String, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
        let cancel = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            self?.hud.dismiss(animated: true)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func restartApp() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
        
        sceneDelegate?.window?.rootViewController = TabBarController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    private func sendNotificationAgain() {
        let calendar = repository.fetchAllCalendar()
        let petList = repository.fetchPet()
        
        if calendar.count != 0 {
            calendar.forEach {
                sendNotification(notiTitle: NotificationContentText.todayCalendar, body: $0.title, date: $0.date, identifier: "\($0.registerDate)", type: .calendar)
            }
        }
        if petList.count != 0 {
            petList.forEach {
                sendNotification(notiTitle: "\($0.petName) 생일", body: NotificationContentText.happyDay, date: $0.birthday!, identifier: "\($0.registerDate)", type: .pet)
            }
        }
    }
}

//MARK: - DocumentPicker
extension BackupRestoreViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("취소됨")
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        hud.show(in: mainView)
        
        backupHandlerAlert(title: AlertTitle.restore, message: AlertMessage.checkRestore) { [weak self] _ in
            
            guard let self = self else { return }
            //            if urls.first?.lastPathComponent.split(separator: "_").first! != "Petmory" {
            //                Analytics.logEvent("Wrong_Backup_File", parameters: [
            //                    "name": "Wrong Backup File Name",
            //                ])
            //                self.hud.dismiss(animated: true)
            //                self.noHandlerAlert(title: AlertTitle.error, message: AlertMessage.notPetmoryFile)
            //                return
            //            } else {
            //
            guard let selectedFile = urls.first else {
                self.hud.dismiss(animated: true)
                self.noHandlerAlert(title: AlertTitle.noFile, message: "")
                return
            }
            
            guard let documentDirectory = self.documentDirectoryPath() else { return }
            
            let sandboxURL = documentDirectory.appendingPathComponent(selectedFile.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: sandboxURL.path) {
                
                let fileName = selectedFile.lastPathComponent
                
                //파일URL
                let fileURL = documentDirectory.appendingPathComponent(fileName)
                
                do {
                    if try self.checkBackupFile(fileURL: fileURL) == true {
                        Analytics.logEvent("Wrong_Backup_File", parameters: [
                            "name": "No Permory txt File",
                        ])
                        self.removeBackupFile(fileName: fileURL)
                        self.hud.dismiss(animated: true)
                        self.noHandlerAlert(title: AlertTitle.error, message: AlertMessage.notPetmoryFile)
                        return
                    }
                } catch {
                    self.hud.dismiss(animated: true)
                }
                
                do {
                    try self.unZipBackupFile(fileURL: fileURL, destination: documentDirectory)
                    
                    let checkValue = self.checkBackupFileExist()
                    if checkValue == false {
                        Analytics.logEvent("Wrong_Backup_File", parameters: [
                            "name": "No Pemory txt File",
                        ])
                        self.removeBackupFile(fileName: fileURL)
                        self.hud.dismiss(animated: true)
                        self.noHandlerAlert(title: AlertTitle.error, message: AlertMessage.notPetmoryFile)
                        return
                    }
                    
                    //                        self.repository.deleteAllMemory(task: self.memory)
                    //                        self.repository.deleteAllPet(task: self.petList)
                    //                        self.repository.deleteAllCalendar(task: self.calendar)
                    self.repository.deleteAll(memory: self.memory, calendar: self.calendar, pet: self.petList)
                    
                    do {
                        let memoryData = try self.fetchJsonData(fileName: BackupFileName.memory)
                        let calendarData = try self.fetchJsonData(fileName: BackupFileName.calendar)
                        let petData = try self.fetchJsonData(fileName: BackupFileName.pet)
                        
                        try self.repository.localRealm.write {
                            guard let memoryData = try self.decodeMemoryData(data: memoryData), let calendarData = try self.decodeCalendarData(data: calendarData), let petListData = try self.decodePetData(data: petData) else { return }
                            //                                guard let calendarData = try self.decodeCalendarData(data: calendarData) else { return }
                            //                                guard let petListData = try self.decodePetData(data: petData) else { return }
                            
                            //                                self.repository.localRealm.add(memoryData)
                            //                                self.repository.localRealm.add(calendarData)
                            //                                self.repository.localRealm.add(petListData)
                            
                            //데이터 전부 추가
                            self.repository.addAll(memory: memoryData, calendar: calendarData, pet: petListData)
                            
                            //알림 다시
//                            self.calendar = self.repository.fetchAllCalendar()
//                            self.petList = self.repository.fetchPet()
//
//                            if self.calendar.count != 0 {
//                                self.calendar.forEach {
//                                    self.sendNotification(notiTitle: NotificationContentText.todayCalendar, body: $0.title, date: $0.date, identifier: "\($0.registerDate)", type: .calendar)
//                                }
//                            }
//                            if self.petList.count != 0 {
//                                self.petList.forEach {
//                                    self.sendNotification(notiTitle: "\($0.petName) 생일", body: NotificationContentText.happyDay, date: $0.birthday!, identifier: "\($0.registerDate)", type: .pet)
//                                }
//                            }
                            self.sendNotificationAgain()
                        }
                        self.hud.dismiss(animated: true)
                        Analytics.logEvent("Restore_Success", parameters: [
                            "name": "Restore Success",
                        ])
                        
                        self.restartApp()
                        
                    } catch {
                        self.hud.dismiss(animated: true)
                        throw ErrorType.fetchJsonDataError
                    }
                } catch {
                    self.hud.dismiss(animated: true)
                    self.noHandlerAlert(title: AlertTitle.failUnzip, message: "")
                }
            } else {
                //앱 내에 없는 경우엔 복사해서 만들어주기
                
                do {
                    try FileManager.default.copyItem(at: selectedFile, to: sandboxURL)
                    let fileName = selectedFile.lastPathComponent
                    
                    //파일URL
                    let fileURL = documentDirectory.appendingPathComponent(fileName)
                    
                    do {
                        if try self.checkBackupFile(fileURL: fileURL) == true {
                            Analytics.logEvent("Wrong_Backup_File", parameters: [
                                "name": "No Permory txt File",
                            ])
                            self.removeBackupFile(fileName: fileURL)
                            self.hud.dismiss(animated: true)
                            self.noHandlerAlert(title: AlertTitle.error, message: AlertMessage.notPetmoryFile)
                            return
                        }
                    } catch {
                        self.hud.dismiss(animated: true)
                        print("에러")
                    }
                    
                    do {
                        try self.unZipBackupFile(fileURL: fileURL, destination: documentDirectory)
                        let checkValue = self.checkBackupFileExist()
                        if checkValue == false {
                            Analytics.logEvent("Wrong_Backup_File", parameters: [
                                "name": "No Permory txt File",
                            ])
                            self.removeBackupFile(fileName: fileURL)
                            self.hud.dismiss(animated: true)
                            self.noHandlerAlert(title: AlertTitle.error, message: AlertMessage.notPetmoryFile)
                            return
                        }
//                        self.repository.deleteAllMemory(task: self.memory)
//                        self.repository.deleteAllPet(task: self.petList)
//                        self.repository.deleteAllCalendar(task: self.calendar)
                        self.repository.deleteAll(memory: self.memory, calendar: self.calendar, pet: self.petList)
                        
                        do {
                            let memoryData = try self.fetchJsonData(fileName: BackupFileName.memory)
                            let calendarData = try self.fetchJsonData(fileName: BackupFileName.calendar)
                            let petData = try self.fetchJsonData(fileName: BackupFileName.pet)
                            
                            try self.repository.localRealm.write {
//                                guard let memoryData = try self.decodeMemoryData(data: memoryData) else { return }
//                                guard let calendarData = try self.decodeCalendarData(data: calendarData) else { return }
//                                guard let petListData = try self.decodePetData(data: petData) else { return }
                                guard let memoryData = try self.decodeMemoryData(data: memoryData), let calendarData = try self.decodeCalendarData(data: calendarData), let petListData = try self.decodePetData(data: petData) else { return }
                                
//                                self.repository.localRealm.add(memoryData)
//                                self.repository.localRealm.add(calendarData)
//                                self.repository.localRealm.add(petListData)
                                self.repository.addAll(memory: memoryData, calendar: calendarData, pet: petListData)
                                
                                //알림 다시
//                                self.calendar = self.repository.fetchAllCalendar()
//                                self.petList = self.repository.fetchPet()
//
//                                if self.calendar.count != 0 {
//                                    self.calendar.forEach {
//                                        self.sendNotification(notiTitle: NotificationContentText.todayCalendar, body: $0.title, date: $0.date, identifier: "\($0.registerDate)", type: .calendar)
//                                    }
//                                }
//                                if self.petList.count != 0 {
//                                    self.petList.forEach {
//                                        self.sendNotification(notiTitle: "\($0.petName) 생일", body: NotificationContentText.happyDay, date: $0.birthday!, identifier: "\($0.registerDate)", type: .pet)
//                                    }
//                                }
                                self.sendNotificationAgain()
                            }
                            self.hud.dismiss(animated: true)
                            Analytics.logEvent("Restore_Success", parameters: [
                                "name": "Restore Success",
                            ])
                            self.restartApp()
                        } catch {
                            self.hud.dismiss(animated: true)
                            throw ErrorType.fetchJsonDataError
                        }
                        
                    } catch {
                        self.hud.dismiss(animated: true)
                        self.noHandlerAlert(title: AlertTitle.failUnzip, message: "")
                    }
                } catch {
                    self.hud.dismiss(animated: true)
                    self.noHandlerAlert(title: AlertTitle.failUnzip, message: "")
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
        
        let restore = UIAlertAction(title: AlertTitle.export, style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            
            let documentPath = self.documentDirectoryPath()
            if let url = documentPath?.appendingPathComponent(fileName) {
                if FileManager.default.fileExists(atPath: url.path) {
                    self.showActivityController(backupUrl: url)
                } else {
                    self.noHandlerAlert(title: AlertTitle.noFile, message: "")
                }
            }
            
        }
        let delete = UIAlertAction(title: ButtonTitle.delete, style: .destructive) { [weak self] _ in
            
            guard let self = self else { return }
            
            self.deleteFileFromDocument(fileName: fileName)
            self.backupFileList = self.fetchZipFile()
            self.mainView.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: ButtonTitle.cancel, style: .cancel)
        
        alert.addAction(restore)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
}

extension BackupRestoreViewController {
    private func sendNotification(notiTitle: String, body: String, date: Date, identifier: String, type: NotificationType) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = .default
        notificationContent.title = notiTitle
        notificationContent.body = body
        
        if type == .calendar {
            var dateComponents = DateComponents()
            dateComponents.year = date.dateComponentFromDate(component: DateComponent.year.rawValue)
            dateComponents.month = date.dateComponentFromDate(component: DateComponent.month.rawValue)
            dateComponents.day = date.dateComponentFromDate(component: DateComponent.day.rawValue)
            dateComponents.hour = 0
            dateComponents.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
            
            notificationCenter.add(request)
        } else {
            var dateComponents = DateComponents()
            dateComponents.month = date.dateComponentFromDate(component: DateComponent.month.rawValue)
            dateComponents.day = date.dateComponentFromDate(component: DateComponent.day.rawValue)
            dateComponents.hour = 0
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
            notificationCenter.add(request)
        }
    }
}
