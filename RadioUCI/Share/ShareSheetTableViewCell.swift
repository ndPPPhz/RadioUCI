//
//  ShareSheetTableViewCell.swift
//  Radio UCI
//
//  Created by Annino De Petra on 23/12/2018.
//  Copyright © 2018 Annino De Petra. All rights reserved.
//

import UIKit

final class ShareSheetTableViewCell: UITableViewCell, ViewDataConfigurable {
	struct ViewData: Equatable {
		var logoImage: UIImage
		var contentString: String
	}

	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var cellImageView: UIImageView!

	func configure(with viewData: ViewData) {
		cellImageView.image = viewData.logoImage
		titleLabel.text = viewData.contentString
	}
}
