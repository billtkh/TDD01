//
//  ListingGroupSelectionViewModel.swift
//  TDD01
//
//  Created by Bill Tsang on 9/12/2021.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

public enum ListingGroupType {
    case commercial
    case resident
}

extension ListingGroupType {
    var title: String {
        switch self {
        case .commercial:
            return "Commercial"
        case .resident:
            return "Resident"
        }
    }
}

public struct ListingGroupViewModel {
    let service: ListingService
    let groupSelection: ListingGroupSelectionViewModel
    
    public struct Input {
        let clearTrigger: Driver<Void>
        let isConnectingTrigger: Driver<Bool>
        let nextTrigger: Driver<Void>
    }
    
    public struct Output {
        let groupSelection: Driver<ListingGroupType>
        let state: Driver<State>
        let isConnected: Driver<Bool>
    }
    
    public init(service: ListingService, groupSelection: ListingGroupSelectionViewModel) {
        self.service = service
        self.groupSelection = groupSelection
    }
    
    public enum State: Equatable {
        case disconnected
        case loading(ListingGroupType)
        case listing([ListingViewModel])
    }
    
    private var state: Observable<State> {
        return Observable.merge(
            isDisconnected(),
            awaitingResponse(),
            displayListing(groupSelection: groupSelection),
            clearListing()
        )
    }
    
    let connectRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let startLoadingRelay: PublishRelay<Void> = PublishRelay()
    private let clearRelay: PublishRelay<Void> = PublishRelay()
    
    private let disposeBag = DisposeBag()
    
    public func transform(input: Input) -> Output {
        input.clearTrigger.drive(onNext: { _ in
            clear()
        }).disposed(by: disposeBag)

        input.isConnectingTrigger.drive(onNext: { isConnecting in
            if isConnecting {
                connect(groupType: groupSelection.selectedType.value)
            } else {
                disconnect()
            }
            
        }).disposed(by: disposeBag)
        
        input.nextTrigger.drive(onNext: { _ in
            groupSelection.next()
        }).disposed(by: disposeBag)
        
        let output = Output(
            groupSelection: groupSelection.selectedType.asDriver(),
            state: state.asDriver(onErrorJustReturn: .disconnected),
            isConnected: connectRelay.asDriver()
        )
        return output
    }
    
    public func connect(groupType: ListingGroupType) {
        connectRelay.accept(true)
        groupSelection.selectedType.accept(groupType)
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
                return .loading(groupSelection.selectedType.value)
            }
    }
    
    private func displayListing(groupSelection: ListingGroupSelectionViewModel) -> Observable<State> {
        groupSelection.selectedType
            .filter({ _ in
                connectRelay.value == true
            }).do(onNext: { _ in
                startLoadingRelay.accept(())
            }).flatMapLatest { type in
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
