//
//  CQWelcomeViewController.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import SDWebImage


class CQWelcomeViewController: UIViewController {
//MARK: - 属性
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var iconBottomDistance: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        iconImageView.layer.cornerRadius = 45
        iconImageView.clipsToBounds = true
        
        assert(CQUserAccount.loadUserAccount() != nil, "必须授权之后才能显示欢迎界面")
        
        let imageUrlStr = CQUserAccount.loadUserAccount()?.avatar_large
        guard let imageUrl = NSURL(string:imageUrlStr!) else{
            return
        }
        iconImageView .sd_setImageWithURL(imageUrl)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        iconBottomDistance.constant = UIScreen.mainScreen().bounds.size.height  - iconBottomDistance.constant
        UIView.animateWithDuration(1, animations: {
            self.view.layoutIfNeeded()

            }) { (_) in
                UIView.animateWithDuration(0.5, animations: {
                    self.nameLabel.alpha = 1.0
                    }, completion: { (_) in
                       NSNotificationCenter.defaultCenter().postNotificationName(CQSwitchRootViewController, object: true)

                })

        }

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    

}
