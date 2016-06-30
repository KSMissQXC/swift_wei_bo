//
//  AppDelegate.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = defaultViewController()
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.changeRootVc(_:)), name: CQSwitchRootViewController, object: nil)
        
        return true
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


extension AppDelegate {
    private func isNewVersion() -> Bool {
        //1.加载plist中的版本号
        
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        //2.加载沙盒中的版本号
        let sanboxVersion = (NSUserDefaults.standardUserDefaults().objectForKey("ooxx") as? String) ??  "0.0"
        
        //3.版本号比较
        if currentVersion.compare(sanboxVersion) == NSComparisonResult.OrderedDescending {
            
            CQLog("有新版本")
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "ooxx")
            
            return true
        }
        CQLog("没有新版本")
        return false
    }
    
    private func defaultViewController() -> UIViewController {
        //登录情况
        var vc = UIViewController()
        if CQUserAccount.isLogin() {
            //是否需要显示新特性界面
            if isNewVersion() {
                 vc = CQNewFeatureCollectionViewController(nibName: "CQNewFeatureCollectionViewController", bundle: nil)
            }else{
                //显示欢迎界面
                 vc = CQWelcomeViewController()
            }
        }else{
            //显示默认界面
            let sb = UIStoryboard(name: "Main", bundle: nil)
            vc = sb.instantiateInitialViewController()!
        }
        return vc
    }
    
    @objc private func changeRootVc(noti:NSNotification) {
        
        var vc  = UIViewController()

        if  noti.object as! Bool {
            //显示默认界面
            let sb = UIStoryboard(name: "Main", bundle: nil)
            vc = sb.instantiateInitialViewController()!
        }else{
            vc = CQWelcomeViewController()
        }
        
//        UIView.transitionFromView((window?.rootViewController?.view)!, toView: vc.view, duration: 2, options: UIViewAnimationOptions.TransitionCrossDissolve) { (_) in
//            
//            self.window?.rootViewController = vc
//        }
        let ca = CATransition()
        ca.type = "push"
        ca.duration = 0.5
        window?.layer.addAnimation(ca, forKey: nil)
        window?.rootViewController = vc;        
    }
}







func CQLog <T>(message : T,fileName : String = #file,methodName : String = #function,lineNumber : Int = #line) {
    #if DEBUG
        print("\(methodName)[\(lineNumber)] : \(message)")
    #endif
    
}



