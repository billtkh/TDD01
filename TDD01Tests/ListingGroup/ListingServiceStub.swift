//
//  ListingServiceStub.swift
//  TDD01Tests
//
//  Created by Bill Tsang on 8/12/2021.
//

import Foundation
import RxSwift
import TDD01

class ListingServiceStub: ListingService {
    let commercialStub: [Listing] = [
        Listing(title: "commercial01"),
        Listing(title: "commercial02"),
        Listing(title: "commercial03"),
        Listing(title: "commercial04"),
        Listing(title: "commercial05"),
        Listing(title: "commercial06"),
        Listing(title: "commercial07"),
    ]
    
    let residentStub: [Listing] = [
        Listing(title: "resident01"),
        Listing(title: "resident02"),
        Listing(title: "resident03"),
        Listing(title: "resident04"),
    ]
    
    func fetch(type: ListingGroupType) -> Single<[Listing]> {
        switch type {
        case .commercial:
            return .just(commercialStub).delay(.milliseconds(10), scheduler: MainScheduler.instance)
        case .resident:
            return .just(residentStub).delay(.milliseconds(10), scheduler: MainScheduler.instance)
        }
    }
}
