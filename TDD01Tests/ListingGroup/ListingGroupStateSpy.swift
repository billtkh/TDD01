//
//  ListingGroupStateSpy.swift
//  TDD01Tests
//
//  Created by Bill Tsang on 8/12/2021.
//

import Foundation
import RxSwift
import TDD01

class ListingGroupStateSpy {
    var stateStack: [ListingGroupViewModel.State] = []
    let disposeBag = DisposeBag()
    
    init(_ observable: Observable<ListingGroupViewModel.State>) {
        observable.subscribe { [weak self] state in
            self?.stateStack.append(state)
        }.disposed(by: disposeBag)
    }
}
