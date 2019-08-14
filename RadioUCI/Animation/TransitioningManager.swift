//
//  TransitioningManager.swift
//  Radio UCI
//
//  Created by Annino De Petra on 11/04/2021.
//  Copyright © 2021 Annino De Petra. All rights reserved.
//

import UIKit

final class TransitioningManager: NSObject, UIViewControllerTransitioningDelegate {
	public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		return PresentationController(presentedViewController: presented, presenting: presenting)
	}

	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return AnimationController()
	}
}
