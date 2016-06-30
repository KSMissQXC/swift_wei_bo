//
//  CQProfileTableViewController.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQProfileTableViewController: CQBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            vistorView?.setupVisitorViewInfo("visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
            return
        }

    }



}
