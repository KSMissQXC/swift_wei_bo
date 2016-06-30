//
//  CQPresentaionController.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQPresentaionController: UIPresentationController {
    /// 保存菜单的尺寸
    var presentFrame = CGRectZero
    
    override func containerViewWillLayoutSubviews() {
 
//        presentedView()?.frame = CGRect(x: 100, y: 64, width: 200, height: 200)
        presentedView()?.frame = presentFrame
        containerView?.insertSubview(coverButton, atIndex: 0)
        coverButton.addTarget(self, action: #selector(CQPresentaionController.coverBtnClick), forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    private lazy var coverButton : UIButton = {
        
        let btn = UIButton()
        btn.backgroundColor = UIColor.clearColor()
        btn.frame = UIScreen.mainScreen().bounds
        return btn
    }()
    
    @objc private func coverBtnClick(){
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)

    }

}
