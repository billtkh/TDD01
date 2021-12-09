//
//  ListingViewModel.swift
//  TDD01
//
//  Created by Bill Tsang on 9/12/2021.
//

import Foundation
import RxSwift
import RxRelay

public struct ListingViewModel {
    let listing: Listing
    let isSelected: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    public init(listing: Listing) {
        self.listing = listing
    }
}

extension ListingViewModel: Equatable {
    public static func == (lhs: ListingViewModel, rhs: ListingViewModel) -> Bool {
        return lhs.listing.title == rhs.listing.title
    }
}
