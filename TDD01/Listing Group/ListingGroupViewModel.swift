//
//  ListingGroupSelectionViewModel.swift
//  TDD01
//
//  Created by Bill Tsang on 9/12/2021.
//

import Foundation
import RxSwift
import RxRelay

public enum ListingGroupType {
    case commercial
    case resident
}

public struct ListingGroupViewModel {
    let service: ListingService
    let groupSelection: ListingGroupSelectionViewModel
    
    public init(service: ListingService, groupSelection: ListingGroupSelectionViewModel) {
        self.service = service
        self.groupSelection = groupSelection
    }
    
    public enum State: Equatable {
        case disconnected
        case listing([ListingViewModel])
        case loading(ListingGroupType)
    }
    
    public var state: Observable<State> {
        return Observable.merge(
            isDisconnected(),
            awaitingResponse(),
            displayListing(groupSelection: groupSelection),
            clearListing()
        )
    }
    
    private let connectRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let startLoadingRelay: PublishRelay<Void> = PublishRelay()
    private let clearRelay: PublishRelay<Void> = PublishRelay()
    
    private let disposeBag = DisposeBag()
    
    public func connect(groupType: ListingGroupType) {
        connectRelay.accept(true)
        groupSelection.type.accept(groupType)
    }
    
    public func disconnect() {
        connectRelay.accept(false)
    }
    
    public func clear() {
        clearRelay.accept(())
    }
}

extension ListingGroupViewModel {
    private func isDisconnected() -> Observable<State> {
        connectRelay
            .filter({ $0 == false })
            .map({ _ in
                print("[DEBUG] disconnected")
                return .disconnected
            })
    }
    
    private func awaitingResponse() -> Observable<State> {
        startLoadingRelay
            .map { [groupSelection] _ in
                print("[DEBUG] start loading")
                return .loading(groupSelection.type.value)
            }
    }
    
    private func displayListing(groupSelection: ListingGroupSelectionViewModel) -> Observable<State> {
        groupSelection.type
            .skip(while: { _ in connectRelay.value == false })
            .do(onNext: { _ in startLoadingRelay.accept(()) })
            .flatMapLatest { [service] type in
                service.fetch(type: type)
            }.map { listings in
                print("[DEBUG] displaying listings")
                return .listing(listings.map { ListingViewModel(listing: $0) })
            }
    }
    
    private func clearListing() -> Observable<State> {
        clearRelay
            .map { _ in
                print("[DEBUG] clear")
                return .listing([])
            }
    }
}
