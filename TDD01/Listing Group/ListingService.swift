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

public class ListingServiceStub: ListingService {
    let delay: Int // milliseconds
    
    public let commercialStub: [Listing] = [
        Listing(title: "commercial01"),
        Listing(title: "commercial02"),
        Listing(title: "commercial03"),
        Listing(title: "commercial04"),
        Listing(title: "commercial05"),
        Listing(title: "commercial06"),
        Listing(title: "commercial07"),
    ]
    
    public let residentStub: [Listing] = [
        Listing(title: "resident01"),
        Listing(title: "resident02"),
        Listing(title: "resident03"),
        Listing(title: "resident04"),
    ]
    
    public init(delay: Int = 10) {
        self.delay = delay
    }
    
    public func fetch(type: ListingGroupType) -> Single<[Listing]> {
        switch type {
        case .commercial:
            return .just(commercialStub).delay(.milliseconds(delay), scheduler: MainScheduler.instance)
        case .resident:
            return .just(residentStub).delay(.milliseconds(delay), scheduler: MainScheduler.instance)
        }
    }
}
