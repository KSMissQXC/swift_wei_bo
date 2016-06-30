//
//  UIButton+Extension.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

extension UIButton{
    
    convenience init(imageName: String, backgroundImageName: String) {
        self.init()
        // 2.设置前景图片
        setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        // 3.设置背景图片
        setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        // 4.调整按钮尺寸
        sizeToFit()

        
    }
    
    
}