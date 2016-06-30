//
//  CQMainController.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQMainController: UITabBarController {
//MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
//        addChildControllers()
        tabBar.addSubview(composeButton)
        composeButton.center.x = tabBar.frame.width * 0.5
        composeButton.center.y = tabBar.frame.height * 0.5
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabBar.bringSubviewToFront(composeButton)
    }
    
//MARK:  懒加载
   private lazy var composeButton : UIButton = {
         let btn = UIButton(imageName:"tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
 
        btn.addTarget(self, action: #selector(CQMainController.compseBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
    
        return btn
    }()
    
//MARK: - 事件方法
@objc private  func compseBtnClick(btn : UIButton){
    
    
        let vc = UIStoryboard(name: "CQCompose", bundle: nil).instantiateInitialViewController()
    
        presentViewController(vc!, animated: true, completion: nil)
    
    
    }
    

  
}
