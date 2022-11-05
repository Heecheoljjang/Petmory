//
//  Protocols.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/11/05.
//

import Foundation

protocol CommonViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
