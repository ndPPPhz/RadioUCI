//
//  Coordinator.swift
//  Radio UCI
//
//  Created by Annino De Petra on 11/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

import UIKit

protocol Coordinator {
	var childCoordinators: [Coordinator] { get }
	var navigationController: UINavigationController { get }
	func start()
}
