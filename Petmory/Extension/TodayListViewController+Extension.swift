//
//  TodayListViewController+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit

extension TodayListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodayListTableViewCell.identifier) as? TodayListTableViewCell else { return UITableViewCell() }
        cell.mainImageView.image = UIImage(systemName: "heart.fill")
        cell.titleLabel.text = tasks[indexPath.row].memoryTitle
        cell.contentLabel.text = tasks[indexPath.row].memoryContent
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
