//
//  CQOAuthViewController.swift
//  CQWB_SWIFT
//
//  Created by 耳动人王 on 16/6/11.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class CQOAuthViewController: UIViewController ,UIWebViewDelegate{
//MARK: - 属性
    
    @IBOutlet weak var customWebView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CQOAuthViewController.dismissClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CQOAuthViewController.fillClick))
        
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_uri)"
       
        guard let url =  NSURL(string: urlStr) else{
            return
        }
        
        let request = NSURLRequest(URL: url)
        customWebView.loadRequest(request)


    }
    
   @objc private func fillClick() {
    
        let jsStr = "document.getElementById('userId').value = '';"
        customWebView.stringByEvaluatingJavaScriptFromString(jsStr)
    
        let pwdStr = "document.getElementById('passwd').value = '';"
        customWebView.stringByEvaluatingJavaScriptFromString(pwdStr)

    
    
    
    }
    
    @objc private func dismissClick() {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showInfoWithStatus("正在加载中", maskType: SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
    
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        guard let urlStr = request.URL?.absoluteString else{
            return false
        }
        
        
        if !urlStr.hasPrefix(WB_Redirect_uri) {
            CQLog("不是授权回调页")
            return true
        }
        
        CQLog("是授权回调页")
        let key = "code="
        if  urlStr.containsString(key){
            
            let code = request.URL?.query?.substringFromIndex(key.endIndex)
            loadAccessToken(code)
            SVProgressHUD.dismiss()
        }
        return false
    }
    
    private func loadAccessToken(codeStr : String?){
        guard let code = codeStr else{
            return
        }
        // 1.准备请求路径
        let path = "oauth2/access_token"
        // 2.准备请求参数
        let parameters = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": WB_Redirect_uri]
        // 3.发送POST请求
        CQNetWorkTools.shareInstance.POST(path, parameters: parameters, success: { ( task :NSURLSessionDataTask, objc : AnyObject?) in
            
            
            let accout = CQUserAccount(dict: objc as! [String : AnyObject])
            
            accout.loadUserInfo({ (account, error) in
                accout.saveAccount()
            NSNotificationCenter.defaultCenter().postNotificationName(CQSwitchRootViewController, object: false)
            self.dismissClick()
            })
            
        
        }) { (task :NSURLSessionDataTask?, error: NSError) in

            
        }
        
    }

}
