//
//  CQNetWorkTools.swift
//  CQWB_SWIFT
//
//  Created by 耳动人王 on 16/6/11.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import AFNetworking

class CQNetWorkTools: AFHTTPSessionManager {
    static let shareInstance : CQNetWorkTools = {
        
        let baseUrl = NSURL(string: "https://api.weibo.com/")!
        let instance = CQNetWorkTools(baseURL: baseUrl, sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set
        return instance

    }()
    
    func loadNewStatuses(since_id : String , finished : (array : [[String : AnyObject]]?,error : NSError?) -> ()) {
        
        assert(CQUserAccount.loadUserAccount() != nil, "获取微博数据必须先授权")
        let path = "2/statuses/home_timeline.json"
        let parameters = ["access_token" : CQUserAccount.account!.access_token!,"since_id" : since_id]
        GET(path, parameters: parameters, progress: { (progress) in
            }, success: { (task, objc) in
                guard let arr = ((objc as! [String : AnyObject])["statuses"] as? [[String : AnyObject]]) else {
                    
                    finished(array: nil, error: NSError(domain: "com.baidu.com", code: 1000, userInfo: ["message" : "没有获取到数据"]))
                    return
                }
                
                finished(array: arr, error: nil)

            }) { (task, error) in
                finished(array: nil, error: error)
        }
    }
    
    func loadMoreStatuses(max_id : String , finished : (array : [[String : AnyObject]]?,error : NSError?) -> ()) {
        assert(CQUserAccount.loadUserAccount() != nil, "获取微博数据必须先授权")
        let path = "2/statuses/home_timeline.json"
       CQLog(max_id)
        let parameters = ["access_token" : CQUserAccount.account!.access_token!,"max_id" : "\(Int(max_id)! - 1)"]
        GET(path, parameters: parameters, progress: { (progress) in
            }, success: { (task, objc) in
                guard let arr = ((objc as! [String : AnyObject])["statuses"] as? [[String : AnyObject]]) else {
                    
                    finished(array: nil, error: NSError(domain: "com.baidu.com", code: 1000, userInfo: ["message" : "没有获取到数据"]))
                    return
                }
                
                finished(array: arr, error: nil)
                
        }) { (task, error) in
            finished(array: nil, error: error)
        }

    }
    
    //发送微博
    func sendStatus(status : String ,image : UIImage?,finfished : (objc : AnyObject?,error : NSError?) -> ()) {
        
        // 定义路径
        var path = "/2/statuses/"
        
        //定义参数
        let parameters = ["access_token": CQUserAccount.loadUserAccount()!.access_token!, "status": status]
        if image == nil {
            
            // 1.获取发送微博的路径
            path += "update.json"
            POST(path, parameters: parameters, progress: { (_) in
                
                }, success: { (task, objc) in
                    finfished(objc: objc, error: nil)
                    
            }) { (task, error) in
                finfished(objc: nil, error: error)
            }

        }else{
            //获取带图片的路径
            path += "upload.json"
            
            //发送微博
            POST(path, parameters: parameters, constructingBodyWithBlock: { (formData) in
                //拼接图片数据
                let data = UIImagePNGRepresentation(image!)
                
                formData.appendPartWithFileData(data!, name: "pic", fileName: "234.png", mimeType: "image/png")
                }, success: { (task, objc) in
                    finfished(objc: objc, error: nil)

                }, failure: { (task, error) in
                    finfished(objc: nil, error: error)

            })

            
        }

    }
    
    
    
    
    
    
    
    
    
    
    

}
