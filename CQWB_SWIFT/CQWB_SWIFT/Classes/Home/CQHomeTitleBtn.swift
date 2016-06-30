//
//  CQHomeTitleBtn.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQHomeTitleBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustsImageWhenHighlighted = false
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up" ), forState: UIControlState.Selected)
        titleLabel?.font = UIFont.systemFontOfSize(17)
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
       
        super.setTitle((title ?? "") + "  ", forState: state)
        sizeToFit()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.size.width)!
    }
    
    
}
