//
//  PhotoViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/29.
//

import Foundation
import RxCocoa
import RxSwift

final class PhotoViewModel: CommonViewModel {
    
    struct Input {
        let imageList: BehaviorRelay<[Data]>
        let collectionViewContentOffset: ControlProperty<CGPoint>
        let tapDismiss: ControlEvent<Void>
    }
    
    struct Output {
        let numberOfPages: Driver<[Data]>
        let collectionViewItem: Driver<[Data]>
        let collectionViewXOffset: Observable<CGFloat>
        let tapDismiss: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let numberOfPages = input.imageList.asDriver(onErrorJustReturn: [])
        let collectionViewItem = input.imageList.asDriver(onErrorJustReturn: [])
        let xOffset = input.collectionViewContentOffset.map { $0.x }
        
        return Output(numberOfPages: numberOfPages, collectionViewItem: collectionViewItem, collectionViewXOffset: xOffset, tapDismiss: input.tapDismiss)
    }
    
    var imageList = BehaviorRelay<[Data]>(value: []) //구독하기 바로 전꺼를 replay하므로 이전화면에서 데이터 전달된걸 받은 상태에서 bind되면 적용될 것 같음
    
    func fetchImageListCount(imageList: [Data]) -> Int {
        return imageList.count
    }

    func pageControlPage(xOffset: CGFloat, width: CGFloat) -> Int {
        return Int(xOffset / width)
    }
}
