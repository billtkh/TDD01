//
//  ListingGroupViewModelTests.swift
//  TDD01Tests
//
//  Created by Bill Tsang on 8/12/2021.
//

import XCTest
import RxSwift
import RxRelay

protocol ListingService {
    func fetch(type: ListingGroupType) -> Single<[Listing]>
}

struct Listing {
    let title: String
}

struct ListingViewModel {
    let listing: Listing
    
    var isSelected: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}

extension ListingViewModel: Equatable {
    static func == (lhs: ListingViewModel, rhs: ListingViewModel) -> Bool {
        return lhs.listing.title == rhs.listing.title
    }
}

enum ListingGroupType {
    case commercial
    case resident
}

struct ListingGroupSelectionViewModel {
    let type: BehaviorRelay<ListingGroupType> = BehaviorRelay(value: .commercial)
}

struct ListingGroupViewModel {
    let service: ListingService
    let groupSelection: ListingGroupSelectionViewModel
    
    enum State: Equatable {
        case disconnected
        case listing([ListingViewModel])
        case loading(ListingGroupType)
    }
    
    var state: Observable<State> {
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
    
    func connect(groupType: ListingGroupType) {
        connectRelay.accept(true)
        groupSelection.type.accept(groupType)
    }
    
    func disconnect() {
        connectRelay.accept(false)
    }
    
    func clear() {
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

class ListingGroupViewModelTests: XCTestCase {
    func test_sut_initialState() {
        let sut = makeSUT()
        let stateSpy = ListingGroupStateSpy(sut.viewModel.state)
        XCTAssertEqual(stateSpy.stateStack, [.disconnected])
    }
    
    func test_sut_loadingState_resident() {
        let sut = makeSUT()
        let stateSpy = ListingGroupStateSpy(sut.viewModel.state)
        sut.viewModel.connect(groupType: .resident)
        let expectation = self.expectation(description: "loading")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [expectation] in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(stateSpy.stateStack, [
            .disconnected,
            .loading(.resident),
            .listing(sut.serviceStub.residentStub.map({ ListingViewModel(listing: $0) }))
        ])
    }
    
    func test_sut_loadingState_commercial() {
        let sut = makeSUT()
        let stateSpy = ListingGroupStateSpy(sut.viewModel.state)
        sut.viewModel.connect(groupType: .commercial)
        let expectation = self.expectation(description: "loading")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [expectation] in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(stateSpy.stateStack, [
            .disconnected,
            .loading(.commercial),
            .listing(sut.serviceStub.commercialStub.map({ ListingViewModel(listing: $0) })),
        ])
    }
    
    func test_sut_loadingState_then_disconnect() {
        let sut = makeSUT()
        let stateSpy = ListingGroupStateSpy(sut.viewModel.state)
        sut.viewModel.connect(groupType: .commercial)
        let expectation = self.expectation(description: "loading")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [expectation] in
            sut.viewModel.disconnect()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(stateSpy.stateStack, [
            .disconnected,
            .loading(.commercial),
            .listing(sut.serviceStub.commercialStub.map({ ListingViewModel(listing: $0) })),
            .disconnected
        ])
    }
    
    func test_sut_loadingState_thenDisconnect_thenClear() {
        let sut = makeSUT()
        let stateSpy = ListingGroupStateSpy(sut.viewModel.state)
        sut.viewModel.connect(groupType: .commercial)
        let expectation = self.expectation(description: "loading")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [expectation] in
            sut.viewModel.clear()
            sut.viewModel.disconnect()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(stateSpy.stateStack, [
            .disconnected,
            .loading(.commercial),
            .listing(sut.serviceStub.commercialStub.map({ ListingViewModel(listing: $0) })),
            .listing([]),
            .disconnected,
        ])
    }
}

extension ListingGroupViewModelTests {
    func makeSUT() -> (viewModel: ListingGroupViewModel, serviceStub: ListingServiceStub) {
        let listingService = ListingServiceStub()
        let groupSelection = ListingGroupSelectionViewModel()
        let viewModel = ListingGroupViewModel(service: listingService, groupSelection: groupSelection)
        return (viewModel: viewModel, serviceStub: listingService)
    }
}
