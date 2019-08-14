//
//  AnimationController.swift
//  Radio UCI
//
//  Created by Annino De Petra on 24/12/2018.
//  Copyright © 2018 Annino De Petra. All rights reserved.
//

import UIKit

final class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
	enum Constant {
		static let duration: TimeInterval = 0.3
	}

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return Constant.duration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let toViewController = transitionContext.viewController(forKey: .to)
		guard let shareSheetTableViewController = toViewController as? ShareSheetTableViewController else {
			fatalError("View controller that is being transitioning to is not a SheetViewController.")
		}

		let containerView = transitionContext.containerView
		containerView.addSubview(shareSheetTableViewController.view)

		let finalFrame = transitionContext.finalFrame(for: shareSheetTableViewController)
		shareSheetTableViewController.view.frame = finalFrame
		shareSheetTableViewController.view.layoutIfNeeded()

		let contentHeight = shareSheetTableViewController.shareHeight
		let initialFrame = transitionContext.finalFrame(for: shareSheetTableViewController)
			.offsetBy(
				dx: 0,
				dy: finalFrame.height
			)

		shareSheetTableViewController.view.frame = initialFrame

		UIView.animate(
			withDuration: Constant.duration,
			delay: 0,
			options: [.curveEaseOut],
			animations: {
				shareSheetTableViewController.view.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height - contentHeight)
		}, completion: { _ in
				let didComplete = !transitionContext.transitionWasCancelled
				transitionContext.completeTransition(didComplete)
			}
		)
	}
}
