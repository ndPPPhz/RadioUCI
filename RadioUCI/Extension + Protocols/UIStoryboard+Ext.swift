//
//  UIStoryboard+Ext.swift
//  Radio UCI
//
//  Created by Annino De Petra on 11/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

import UIKit

extension UIStoryboard {
	static func instantiateFromMainStoryboard<T: UIViewController>(type: T.Type) -> T {
		let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
		guard let viewController = mainStoryboard.instantiateViewController(withIdentifier: T.storyboardName) as? T else {
			fatalError("Unable to instantiate an instance of \(String(describing: self)) with identifier \(T.storyboardName) from Main.storyboard")
		}
		return viewController
	}
}

private extension UIViewController {
	static var storyboardName: String {
		return String(describing: self)
	}
}
