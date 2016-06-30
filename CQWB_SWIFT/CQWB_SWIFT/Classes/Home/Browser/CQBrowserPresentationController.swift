//
//  CQBrowserPresentationController.swift
//  CQWB_SWIFT
//
//  Created by apple on 6/22/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

//protocol CQBrowserPresentationDelegate : NSObjectProtocol {
//    
//    func browserPresentationGetPresentModel(browserPresenationController : CQBrowserPresentationController,indexPath : NSIndexPath) -> CQPresentModel
//    
//}


class CQBrowserPresentationController: UIPresentationController,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning  {
    
    
    /// 定义标记记录当前是否是展现
    private var isPresent = false
    
    ///当前点击的图片的索引
    private  var index : NSIndexPath?
    
    ///保存需要数据的模型
    var presentModel : CQPresentModel?
    
//    /// 代理对象
//    weak var borwserDelegate : CQBrowserPresentationDelegate?{
//        didSet{
//            presentModel = borwserDelegate?.browserPresentationGetPresentModel(self, indexPath: index!)
//            CQLog(presentModel?.newFrame)
//        }
//    }
//    
//    func setDefaultInfo(index : NSIndexPath,borwserDelegate :CQBrowserPresentationDelegate) {
//        self.index = index
//        self.borwserDelegate = borwserDelegate
//    }
    
    
    
    

    
    // MARK: - UIViewControllerTransitioningDelegate
    // 该方法用于返回一个负责转场动画的对象
    // 可以在该对象中控制弹出视图的尺寸等
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        return CQBrowserPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    // 该方法用于返回一个负责转场如何出现的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        return self
    }
    
    // 该方法用于返回一个负责转场如何消失的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = false
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    // 告诉系统展现和消失的动画时长
    // 暂时用不上
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
    
    // 专门用于管理modal如何展现和消失的, 无论是展现还是消失都会调用该方法
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        // 0.判断当前是展现还是消失
        if isPresent
        {
            // 展现
            willPresentedController(transitionContext)
            
        }else
        {
            // 消失
            willDismissedController(transitionContext)
        }
    }
    
    /// 执行展现动画
    private func willPresentedController(transitionContext: UIViewControllerContextTransitioning)
    {
        
//        assert(index != nil, "必须设置被点击cell的indexPath")
        assert(presentModel != nil, "必须设置展示模型")
        
        // 1.获取需要弹出视图
        // 通过ToViewKey取出的就是toVC对应的view
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else
        {
            return
        }
        
//        // 2.1.新建一个UIImageView, 并且上面显示的内容必须和被点击的图片一模一样
        let imageView = UIImageView()
        imageView.image = presentModel?.image
        
//        // 2.2.获取点击图片相对于window的frame, 因为容器视图是全屏的, 而图片是添加到容器视图上的, 所以必须获取相对于window的frame
        imageView.frame = (presentModel?.newFrame)!
        transitionContext.containerView()?.addSubview(imageView)
//        // 2.3.获取点击图片最终显示的尺寸
        let toFrame = presentModel?.toFrame
        
        // 3.执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            imageView.frame = toFrame!
        }) { (_) -> Void in
            
             //移除自己添加的UIImageView
            imageView.removeFromSuperview()
            
            // 显示图片浏览器
            transitionContext.containerView()?.addSubview(toView)
            toView.frame = (transitionContext.containerView()?.bounds)!
            
            // 告诉系统动画执行完毕
            transitionContext.completeTransition(true)
        }
        
        //        transitionContext.containerView()?.addSubview(toView)
        
    }
    
    /// 执行消失动画
    private func willDismissedController(transitionContext: UIViewControllerContextTransitioning)
    {
        // 通过ToViewKey取出的就是FromVC对应的view
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else
        {
            return
        }
        
        //先移除上面控制器的View
    

        fromView.removeFromSuperview()
        
        
        //拿到控制器中的图片
        
        //获取image
        let imageView = UIImageView()
        imageView.image = presentModel?.image
        imageView.frame = (presentModel?.toFrame)!
        transitionContext.containerView()?.addSubview(imageView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
            imageView.frame = (self.presentModel?.newFrame)!
            }) { (_) in
                transitionContext.completeTransition(true)
        }

    }


}


class CQPresentModel: NSObject {
    
    ///高清的图片,用户体验会更好
    var image : UIImage?
    var  oldFrame : CGRect = CGRectZero
    var  newFrame : CGRect = CGRectZero
    var  toFrame : CGRect = CGRectZero
    var collectionView : UICollectionView?

    
}






