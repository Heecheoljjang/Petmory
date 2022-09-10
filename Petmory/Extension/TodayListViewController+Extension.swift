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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodayListTableViewCell.identifier) as? TodayListTableViewCell else { return UITableViewCell() }
        cell.mainImageView.image = UIImage(systemName: "heart.fill")
        cell.titleLabel.text = "12312313412312312312345654654723464312654235"
        cell.contentLabel.text = "564535645356436546554565465465464645645654"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
