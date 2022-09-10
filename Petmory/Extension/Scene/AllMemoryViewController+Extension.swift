//
//  AllMemoryViewController+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit

//MARK: - TableView
extension AllMemoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllMemoryTableViewCell.identifier, for: indexPath) as? AllMemoryTableViewCell else { return UITableViewCell() }
        
        cell.memoryTitle.text = tasks[indexPath.row].memoryTitle
        cell.memoryDate.text = "\(tasks[indexPath.row].memoryDate)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

//MARK: - CollectionView

extension AllMemoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllMemoryCollectionViewCell.identifier, for: indexPath) as? AllMemoryCollectionViewCell else { return UICollectionViewCell() }
        cell.nameLabel.text = petList[indexPath.item].petName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellSize = CGSize(width: petList[indexPath.item].petName.size(withAttributes: nil).width + 20, height: 52)
        return cellSize
    }
}
