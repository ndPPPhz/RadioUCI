//
//  AppDelegate.swift
//  Radio UCI
//
//  Created by Annino De Petra on 15/03/2018.
//  Copyright © 2018 Annino De Petra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	private var mainCoordinator: MainCoordinator?

	private func setupWindowAndReturnMainNavigationController() -> UINavigationController {
		window = UIWindow(frame: UIScreen.main.bounds)
		let radioUCINavigationController = RadioUCINavigationController()
		window?.rootViewController = radioUCINavigationController
		window?.makeKeyAndVisible()
		return radioUCINavigationController
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let navigationController = setupWindowAndReturnMainNavigationController()
		let coordinator = MainCoordinator(navigationController: navigationController)
		coordinator.start()
		mainCoordinator = coordinator
		return true
	}
}

