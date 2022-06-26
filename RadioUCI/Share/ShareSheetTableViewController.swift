//
//  ShareSheetTableViewController.swift
//  Radio UCI
//
//  Created by Annino De Petra on 23/12/2018.
//  Copyright © 2018 Annino De Petra. All rights reserved.
//

import UIKit

final class ShareSheetTableViewController: UITableViewController {
	var shareOptions: [ShareOption] = [] {
		didSet {
			tableView.reloadData()
		}
	}

	var urlHandler: URLOpenHandler = UIApplication.shared

	private func setupTableView() {
		tableView.contentInset.top = 0
		tableView.contentInset.bottom = 24
		tableView.layer.cornerRadius = 12
		tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			let cell = tableView.dequeueReusableCell(withIdentifier: "shareCell", for: indexPath) as? ShareSheetTableViewCell
		else {
			assertionFailure("Unable to deque a cell of type ShareSheetTableViewCell at indexPath \(indexPath)")
			return UITableViewCell()
		}

		guard let shareOption = shareOptions[safe: indexPath.row] else {
			assertionFailure("Unable to get a share option at indexPath \(indexPath)")
			return UITableViewCell()
		}

		cell.configure(with: shareOption.asShareViewData)
        return cell
    }

	var shareHeight: CGFloat {
		return tableView.contentSize.height + tableView.contentInset.top + tableView.contentInset.bottom
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let url = shareOptions[indexPath.row].url
		if urlHandler.canOpenURL(url) {
			urlHandler.open(url) { [weak self] _ in
				self?.dismiss(animated: UIView.areAnimationsEnabled)
			}
		}
	}
}

private extension ShareOption {
	var asShareViewData: ShareSheetTableViewCell.ViewData {
		return .init(
			logoImage: UIImage(named: image) ?? UIImage.init(named: "LogoRadioUCI")!,
			contentString: name
		)
	}
}
