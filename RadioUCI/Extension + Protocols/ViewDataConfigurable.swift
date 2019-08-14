//
//  ViewDataConfigurable.swift
//  Radio UCI
//
//  Created by Annino De Petra on 09/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

protocol ViewDataConfigurable {
	associatedtype ViewData: Equatable
	func configure(with viewData: ViewData)
}
