//
//  MainCoordinator.swift
//  Radio UCI
//
//  Created by Annino De Petra on 11/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

import UIKit

protocol RadioUCICoordinatorInterface: AnyObject {
	func showContactsSheet(shareOptions: [ShareOption])
}

final class MainCoordinator: Coordinator, RadioUCICoordinatorInterface {
	var childCoordinators: [Coordinator] = []
	let navigationController: UINavigationController
	private lazy var transitioningManager: UIViewControllerTransitioningDelegate = TransitioningManager()

	private func setupNavigationBarAppearance() {
		// Override point for customization after application launch.
		let navigationBarAppearance = UINavigationBar.appearance()

		navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
		// Sets shadow (line below the bar) to a blank image
		navigationBarAppearance.shadowImage = UIImage()
		// Sets the translucent background color
		navigationBarAppearance.backgroundColor = .clear
		// Set translucent. (Default value is already true, so this can be removed if desired.)
		navigationBarAppearance.isTranslucent = true

		navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
	}

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		setupNavigationBarAppearance()
		let playerViewController = UIStoryboard.instantiateFromMainStoryboard(type: PlayerViewController.self)
		playerViewController.radioUCICoordinator = self
		navigationController.setViewControllers([playerViewController], animated: false)
	}

	func showContactsSheet(shareOptions: [ShareOption]) {
		let shareSheetTableViewController = UIStoryboard.instantiateFromMainStoryboard(type: ShareSheetTableViewController.self)
		shareSheetTableViewController.shareOptions = shareOptions
		shareSheetTableViewController.modalPresentationStyle = .custom
		shareSheetTableViewController.transitioningDelegate = transitioningManager
		navigationController.present(shareSheetTableViewController, animated: true, completion: nil)
	}
}
