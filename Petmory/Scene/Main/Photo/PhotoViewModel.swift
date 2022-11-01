//
//  PhotoViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/29.
//

import Foundation
import RealmSwift

final class PhotoViewModel {
    
    var imageList: MVVMObservable<[Data]> = MVVMObservable([])
    
    func fetchImageListCount() -> Int {
        return imageList.value.count
    }
    
    func pageControlPage(xOffset: Double, width: CGFloat) -> Int {
        return Int(xOffset / width)
    }
}
