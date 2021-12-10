//
//  ListingGroupSelectionViewModel.swift
//  TDD01
//
//  Created by Bill Tsang on 9/12/2021.
//

import Foundation
import RxSwift
import RxRelay

public struct ListingGroupSelectionViewModel {
    let selections: [ListingGroupType]
    let selectedType: BehaviorRelay<ListingGroupType>
    
    public init(selections: [ListingGroupType] = [.commercial, .resident]) {
        self.selections = selections
        self.selectedType = BehaviorRelay(value: selections.first!)
    }
    
    func next() {
        let index = selections.firstIndex(of: selectedType.value) ?? 0
        let nextIndex = index + 1 < selections.count ? index + 1 : 0
        selectedType.accept(selections[nextIndex])
    }
}
