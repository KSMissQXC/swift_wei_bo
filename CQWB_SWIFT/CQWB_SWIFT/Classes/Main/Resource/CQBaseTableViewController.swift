//
//  CQBaseTableViewController.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQBaseTableViewController: UITableViewController {
    
    var isLogin = CQUserAccount.isLogin()
    var vistorView = CQVisitorView?()
//MARK: - 初始化
    override func loadView() {
        
        isLogin ? super.loadView() : setupVistorView()
        
    }
    
    
    func setupVistorView() {
        vistorView = CQVisitorView.visitorView()
        view = vistorView
        
        
        vistorView?.loginBtn.addTarget(self, action: #selector(CQBaseTableViewController.registerDidClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        vistorView?.registerBtn.addTarget(self, action: #selector(CQBaseTableViewController.loginDidClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Done, target: self, action: #selector(CQBaseTableViewController.registerDidClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Done, target: self, action: #selector(CQBaseTableViewController.loginDidClick))
        
        
    }
    

    
    @objc private func registerDidClick(){
        CQLog("---")
    }
    
    @objc private func loginDidClick(){
        let vc = CQOAuthViewController()
        
        
        let nav = UINavigationController(rootViewController: vc)
        
//        navigationController?.pushViewController(vc, animated: true)
        
        
        presentViewController(nav, animated: true, completion: nil)

    }
    
    
  
    

    
    
    
    
    

}
