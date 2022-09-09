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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllMemoryTableViewCell.identifier, for: indexPath) as? AllMemoryTableViewCell else { return UITableViewCell() }
        
        cell.memoryTitle.text = "제목"
        cell.memoryDate.text = "2022년 9월 10일"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

//MARK: - CollectionView

extension AllMemoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllMemoryCollectionViewCell.identifier, for: indexPath) as? AllMemoryCollectionViewCell else { return UICollectionViewCell() }
        cell.nameLabel.text = "두부두부"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let cellSize = CGSize(width: topicList[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width + 20, height: 30)
//        return cellSize
        let cellSize = CGSize(width: "두부두부".size(withAttributes: nil).width + 20, height: 52)
        return cellSize
    }
}
