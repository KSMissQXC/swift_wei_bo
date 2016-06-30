//
//  CQDiscoverTableController.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQDiscoverTableController: CQBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin{
            vistorView?.setupVisitorViewInfo("visitordiscover_image_message", title: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
            return
            
        }
        
        

    }
}
