//
//  AppDelegate.swift
//  TDD01
//
//  Created by Bill Tsang on 8/12/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = makeListingGroupView()
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    func makeListingGroupView() -> UIViewController {
        let listingService = ListingServiceStub(delay: 1000)
        let groupSelection = ListingGroupSelectionViewModel()
        let viewModel = ListingGroupViewModel(service: listingService, groupSelection: groupSelection)
        return UINavigationController(rootViewController: ListingGroupViewController(viewModel: viewModel))
    }
}

