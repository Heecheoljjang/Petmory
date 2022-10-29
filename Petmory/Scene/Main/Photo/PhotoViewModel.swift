//
//  PhotoViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/29.
//

import Foundation
import RealmSwift

final class PhotoViewModel {
    
    var imageList: Observable<List<Data>?> = Observable(nil)
    
    func fetchImageListCount() -> Int {
        return imageList.value?.count ?? 0
    }
    
    func pageControlPage(xOffset: Double, width: CGFloat) -> Int {
        return Int(xOffset / width)
    }
}
