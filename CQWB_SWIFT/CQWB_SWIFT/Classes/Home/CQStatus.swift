//
//  CQStatus.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQStatus: NSObject {
    /// 微博创建时间
    var created_at: String?
    
    /// 字符串型的微博ID
    var idstr: String?
    
    /// 微博信息内容
    var text: String?
    
    /// 微博作者的用户信息
    var  user : CQUser?
    
    /// 配图数组
    var pic_urls: [[String: AnyObject]]?
    
    /// 转发微博
    var retweeted_status: CQStatus?
    
    /// 微博来源
    var source: String?
    init(dict :[String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user" {
            user = CQUser(dict: (value as! [String : AnyObject]))
            return
        }
        
        if key == "retweeted_status" {
            retweeted_status = CQStatus(dict: (value as! [String : AnyObject]))
            return
        }

        super.setValue(value, forKey: key)

    }
    
    override var description: String{
        let property = ["created_at","idstr","text","source"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }


}
