//
//  FlipDismissAnimationController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 6/30/20.
//  Copyright © 2020 whatspoppinREPO. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let destinationFrame: CGRect
    
    init(destinationFrame: CGRect) {
      self.destinationFrame = destinationFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      guard let fromVC = transitionContext.viewController(forKey: .from),
        let toVC = transitionContext.viewController(forKey: .to),
        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
        else {
          return
      }

      snapshot.layer.cornerRadius = 30
      snapshot.layer.masksToBounds = true

      // 2
      let containerView = transitionContext.containerView
//      containerView.insertSubview(toVC.view, at: 0)
      containerView.addSubview(snapshot)
      fromVC.view.isHidden = true

      // 3
      AnimationHelper.perspectiveTransform(for: containerView)
      toVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
      let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
          withDuration: duration,
          delay: 0,
          options: .calculationModeCubic,
          animations: {
            // 1
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
              snapshot.frame = self.destinationFrame
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
              snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
              toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
            }
        },
          // 2
          completion:
            { _ in
                fromVC.view.isHidden = false
                snapshot.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                    toVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
