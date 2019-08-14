//
//  Collection+Ext.swift
//  Radio UCI
//
//  Created by Annino De Petra on 10/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

import Foundation

extension Array {
	subscript (safe index: Int) -> Array.Element? {
		get {
			guard index < count else {
				return nil
			}
			return self[index]
		}

		set {
			guard
				index < count,
				let newValue = newValue
			else {
				return
			}
			self[index] = newValue
		}
	}
}
