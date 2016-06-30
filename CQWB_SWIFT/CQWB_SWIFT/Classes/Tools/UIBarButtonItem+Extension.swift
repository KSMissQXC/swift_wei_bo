//
//  UIBarButtonItem+Extension.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
   convenience init(imageName : String,target : AnyObject?,action : Selector){
    
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        self.init(customView:btn)
    }
    
    
}