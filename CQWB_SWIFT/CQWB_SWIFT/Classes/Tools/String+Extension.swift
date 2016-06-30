//
//  String+Extension.swift
//  CQWB_SWIFT
//
//  Created by 耳动人王 on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

extension String{
    
    /// 快速生成缓存路径
    func cachesDir() -> String {
        
        // 1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)
        return filePath
    }
    
     /// 快速生成文档路径
    func docDir() -> String {
        // 1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)
        return filePath
    }
    
    /// 快速生成临时路径
    func temDir() -> String {
        let path = NSTemporaryDirectory()
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)
        return filePath
    }


    
    
    
}
