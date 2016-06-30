//
//  CQMessageTableViewController.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQMessageTableViewController: CQBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            vistorView?.setupVisitorViewInfo("visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
            return
        }


    }
}
