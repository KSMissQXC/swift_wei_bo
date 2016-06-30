//
//  CQPresentationManager.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit






class CQPresentationManager: NSObject ,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    
    private var isPresent = false
    /// 保存菜单的尺寸
    var presentFrame = CGRectZero

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        
        let pc = CQPresentaionController(presentedViewController: presented, presentingViewController: presenting)
        pc.presentFrame =  presentFrame
        return pc

    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = true
        NSNotificationCenter.defaultCenter().postNotificationName(CQPResentationManagerDidPresented, object: self)
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = false
        NSNotificationCenter.defaultCenter().postNotificationName(CQPResentationManagerDidDismissed, object: self)
        return self
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        
        return 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        
        if isPresent {
            willPresentController(transitionContext)
        }else {
            willDismissController(transitionContext)
        }
    }
    
   private func willPresentController(transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else{
            return
        }
        transitionContext.containerView()?.addSubview(toView)
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            toView.transform = CGAffineTransformIdentity
            }, completion: { (_) in
                transitionContext.completeTransition(true)
        })
    }
    
   private func willDismissController(transitionContext: UIViewControllerContextTransitioning){
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else{
            return
        }
        transitionContext.containerView()?.addSubview(fromView)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.001)
            }, completion: { (_) in
                transitionContext.completeTransition(true)
        })
        
    }
 
    
}

