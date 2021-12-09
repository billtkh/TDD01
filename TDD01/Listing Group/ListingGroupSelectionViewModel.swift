//
//  ListingGroupSelectionViewModel.swift
//  TDD01
//
//  Created by Bill Tsang on 9/12/2021.
//

import Foundation

public struct ListingGroupSelectionViewModel {
    let type: BehaviorRelay<ListingGroupType> = BehaviorRelay(value: .commercial)
    
    public init() { }
}
