//
//  SearchViewController+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultVC.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier) as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.memoryTitle.text = resultVC.tasks[indexPath.row].memoryTitle
        cell.memoryDate.text = "\(resultVC.tasks[indexPath.row].memoryDate)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        resultVC.tasks = repository.fetchSearched(keyword: text)
        resultVC.mainView.tableView.reloadData()
    }
    
}
