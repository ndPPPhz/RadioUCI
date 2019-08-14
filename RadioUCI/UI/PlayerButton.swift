//
//  PlayerButton.swift
//  Radio UCI
//
//  Created by Annino De Petra on 15/03/2018.
//  Copyright © 2018 Annino De Petra. All rights reserved.
//

import UIKit

final class PlayerButton: UIButton, ViewDataConfigurable {
	private enum Constant {
		static let animationDuration: TimeInterval = 0.53
		static let springWithDampingRation: CGFloat = 0.8
		static let delay: TimeInterval = 0
		static let initialSpringVelocity: CGFloat = 1
		static let animationOption: UIView.AnimationOptions = .curveEaseIn
		static let animationZoomScaleFactor: CGFloat = 0.8
	}

	struct ViewData: Equatable {
		var playImage: UIImage
		var pauseImage: UIImage
	}

	enum Appearance {
		case play
		case pause
	}

	private var viewData: ViewData?

	private lazy var tapGesture: UITapGestureRecognizer = {
		return UITapGestureRecognizer(target: self, action: #selector(tapGestureDidRecognize))
	}()

	private lazy var longPressGesture: UILongPressGestureRecognizer = {
		return UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureDidRecognize))
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupUI()
	}

	private func setupUI() {
		addGestureRecognizer(tapGesture)
		addGestureRecognizer(longPressGesture)
	}

	private func executeAnimation(closure: @escaping () -> Void, completionBlock: (() -> Void)? = nil) {
		UIView.animate(
			withDuration: Constant.animationDuration,
			delay: Constant.delay,
			usingSpringWithDamping: Constant.springWithDampingRation,
			initialSpringVelocity: Constant.initialSpringVelocity,
			options: Constant.animationOption,
			animations: {
				closure()
			}, completion: { didCompleteAnimation in
				if didCompleteAnimation {
					completionBlock?()
				}
			})
	}

	@objc private func tapGestureDidRecognize(gesture: UITapGestureRecognizer) {
		sendActions(for: .touchUpInside)

		switch gesture.state {
		case .ended, .cancelled:
			executeAnimation {
				self.transform = CGAffineTransform(scaleX: Constant.animationZoomScaleFactor, y: Constant.animationZoomScaleFactor)
			} completionBlock: {
				self.transform = .identity
			}
		default:
			return
		}
	}

	@objc private func longPressGestureDidRecognize(gesture: UILongPressGestureRecognizer) {
		switch gesture.state {
		case .began:
			executeAnimation {
				self.transform = CGAffineTransform(scaleX: Constant.animationZoomScaleFactor, y: Constant.animationZoomScaleFactor)
			}
		case .ended:
			sendActions(for: .touchUpInside)
			executeAnimation {
				self.transform = .identity
			}
		default:
			return
		}
	}

	func configure(with viewData: ViewData) {
		self.viewData = viewData
	}

	func setAppearance(_ appearance: Appearance) {
		guard let viewData = viewData else {
			return
		}

		switch appearance {
		case .pause:
			setBackgroundImage(viewData.pauseImage, for: .normal)
		case .play:
			setBackgroundImage(viewData.playImage, for: .normal)
		}
	}
}
