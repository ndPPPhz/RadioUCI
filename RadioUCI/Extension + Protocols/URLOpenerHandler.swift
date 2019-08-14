//
//  URLOpenerHandler.swift
//  Radio UCI
//
//  Created by Annino De Petra on 10/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

import UIKit

protocol URLOpenHandler {
	func canOpenURL(_ url: URL) -> Bool
	func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
}

extension URLOpenHandler {
	func open(_ url: URL, completionHandler completion: ((Bool) -> Void)?) {
		open(url, options: [:], completionHandler: completion)
	}
}

extension UIApplication: URLOpenHandler {}
