//
//  ListingGroupViewModelTests.swift
//  TDD01Tests
//
//  Created by Bill Tsang on 8/12/2021.
//

import XCTest
import RxSwift
import RxRelay
import TDD01

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
        let expectation = expectation(description: "loading")
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
        let expectation = expectation(description: "loading")
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
        let expectation = expectation(description: "loading")
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
        let expectation = expectation(description: "loading")
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
