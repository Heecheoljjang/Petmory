//
//  SettingViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/20.
//

import UIKit
import RealmSwift

final class SettingViewController: BaseViewController {
    
    var mainView = SettingView()

    let repository = UserRepository()
    
    let settingList = [SettingList.backup, SettingList.restore, SettingList.message, SettingList.review, SettingList.shareApp]
    
    var memory: Results<UserMemory>!
    
    var calendar: Results<UserCalendar>!
    
    var petList: Results<UserPet>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memory = repository.fetchAllMemory()
        calendar = repository.fetchAllCalendar()
        petList = repository.fetchPet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(memory)
        print(calendar)
        print(petList)
    }
    
    override func setUpController() {
        super.setUpController()
        
        navigationItem.title = "설정"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier) as? SettingTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = settingList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            handlerAlert(title: "백업 파일을 만드시겠습니까?", message: nil) { [weak self] _ in
                self?.backup()
            }
        } else if indexPath.row == 1 {
            handlerAlert(title: "데이터가 덮어씌워집니다. 진행하시겠습니까?", message: nil) { [weak self] _ in
                
                guard let self = self else { return }
                
                self.repository.deleteAllMemory(task: self.memory)
                self.repository.deleteAllPet(task: self.petList)
                self.repository.deleteAllCalendar(task: self.calendar)
                
                do {
                    let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
                    documentPicker.delegate = self
                    documentPicker.allowsMultipleSelection = false
                    self.present(documentPicker, animated: true)
                    
                }
            }
        }
    }
}

extension SettingViewController {
    private func backup() {
        do {
            try saveEncodedMemoryToDocument(data: memory, fileName: BackupFileName.memory)
            try saveEncodedCalendarToDocument(data: calendar, fileName: BackupFileName.calendar)
            try saveEncodedPetToDocument(data: petList, fileName: BackupFileName.pet)
            
            let backupFilePath = try zipBackupFile()
            
            showActivityController(backupUrl: backupFilePath)
            
            fetchZipFile()
        } catch {
            noHandlerAlert(title: "압축 실패", message: "다시 확인해주세요.")
        }
    }
}

extension SettingViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("취소됨")
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFile = urls.first else {
            noHandlerAlert(title: "선택하신 파일을 찾을 수 없습니다.", message: "")
            return
        }
        
        guard let documentDirectory = getDocumentDirectoryPath() else { return }
        
        let sandboxURL = documentDirectory.appendingPathComponent(selectedFile.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxURL.path) {
            
            let fileName = selectedFile.lastPathComponent
            print("fileName: \(fileName)")
            
            //파일URL
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            print("fileURL: \(fileURL)")
            
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
                print("fileName: \(fileName)")
                
                //파일URL
                let fileURL = documentDirectory.appendingPathComponent(fileName)
                print("fileURL: \(fileURL)")
                
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
