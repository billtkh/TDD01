//
//  ListingService.swift
//  TDD01
//
//  Created by Bill Tsang on 9/12/2021.
//

import Foundation
import RxSwift

public protocol ListingService {
    func fetch(type: ListingGroupType) -> Single<[Listing]>
}
