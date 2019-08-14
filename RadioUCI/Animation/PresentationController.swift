//
//  PresentationController.swift
//  Radio UCI
//
//  Created by Annino De Petra on 23/12/2018.
//  Copyright © 2018 Annino De Petra. All rights reserved.
//

import UIKit

final class PresentationController: UIPresentationController {
	private lazy var dimmingView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		return view
	}()

	private lazy var dimmingViewTapGestureRecogniser: UITapGestureRecognizer = {
		let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(dismissPresentedViewController))
		gestureRecogniser.delegate = self
		return gestureRecogniser
	}()

	@objc private func dismissPresentedViewController() {
		presentingViewController.dismiss(animated: true)
	}

	override func containerViewWillLayoutSubviews() {
		guard let containerView = containerView else {
			return
		}

		containerView.insertSubview(dimmingView, at: 0)

		dimmingView.frame = containerView.bounds
		dimmingView.alpha = 0
		dimmingView.addGestureRecognizer(dimmingViewTapGestureRecogniser)

		UIView.animate(withDuration: AnimationController.Constant.duration, delay: 0, options: .curveEaseOut, animations: {
			self.dimmingView.alpha = 1
		})
	}

	override func dismissalTransitionWillBegin() {
		UIView.animate(withDuration: AnimationController.Constant.duration, delay: 0, options: .curveEaseOut, animations: {
			self.dimmingView.alpha = 0
		})
	}
}

// MARK: - UIGestureRecognizerDelegate

extension PresentationController: UIGestureRecognizerDelegate {
	@objc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		// Only allow dismissing when view or container is tapped
		let isDimmingViewTapped = touch.view == dimmingView
		return isDimmingViewTapped
	}
}
