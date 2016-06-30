//
//  CQUserAccount.swift
//  CQWB_SWIFT
//
//  Created by 耳动人王 on 16/6/11.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQUserAccount: NSObject,NSCoding{
    //MARK: - 属性
    var access_token : String?
    var expires_in : Int = 0 {
        didSet{
            expires_Date = NSDate(timeIntervalSinceNow: NSTimeInterval(expires_in))
        }
    }
    var expires_Date : NSDate?
    ///  用户头像地址（大图），180×180像素
    var avatar_large : String?
    /// 用户昵称
    var screen_name: String?

    
    
    var uid : String?
    static var account : CQUserAccount?
    static let filePath  = "useAccount.plist".cachesDir()
    
    //MARK: - 初始化方法
    init(dict : [String : AnyObject]) {
        
        super.init()
        self.setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{
        let property = ["access_token", "expires_in", "uid"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"

    }
    
    // MARK: - 类方法
    class func isLogin() -> Bool {
        return loadUserAccount() != nil
    }
    
    class func loadUserAccount() -> CQUserAccount? {
        if CQUserAccount.account != nil {
            CQLog("已经加载过了")
            return CQUserAccount.account
        }
        guard let account = NSKeyedUnarchiver.unarchiveObjectWithFile(CQUserAccount.filePath) as? CQUserAccount else{
            
            return nil
        }
        
        guard let date = account.expires_Date where date.compare(NSDate()) != NSComparisonResult.OrderedAscending else{
            CQLog("授权过期,请重新授权")
            return nil
        }
        CQUserAccount.account = account
        return CQUserAccount.account
        
    }
    
    

    
    // MARK: - 外部控制方法
    // 归档模型
    func saveAccount() -> Bool {
        return NSKeyedArchiver.archiveRootObject(self, toFile: CQUserAccount.filePath)
    }
    
    func loadUserInfo(finished : (account : CQUserAccount?,error : NSError?) -> ()){
        
        //断言
        assert(access_token != nil, "使用该方法必须先授权")
        let path = "2/users/show.json"
        let parameters = ["access_token" : access_token!,"uid" : uid!]
        CQNetWorkTools.shareInstance.GET(path, parameters: parameters, success: { (task, objc) in
            let dict = objc as! [String : AnyObject]

            self.avatar_large = dict["avatar_large"] as? String
            self.screen_name = dict["screen_name"] as? String

            finished(account: self, error: nil)
            }) { (task, error) in
                finished(account: nil, error: error)
        }

    }
    
   
    


    
    
    
    // MARK: - NScoding协议

     func encodeWithCoder(aCoder: NSCoder){
    
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeInteger(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    
    }
    
     required init?(coder aDecoder: NSCoder){

        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeIntegerForKey("expires_in")
        uid = aDecoder.decodeObjectForKey("uid") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate

        
    }


}
