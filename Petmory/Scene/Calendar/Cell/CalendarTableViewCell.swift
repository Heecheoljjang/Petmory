//
//  CalendarTableViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import UIKit
import SnapKit

final class CalendarTableViewCell: BaseTableViewCell {
    
    let colorView: UIView = {
        let view = UIView()
        
        return view
    }()
    
//    let 
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: CalendarTableViewCell.identifier)
    }
    
}
