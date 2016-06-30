//
//  CQStatusViewModel.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import SDWebImage


class CQStatusViewModel: NSObject {
    //MARK: - 属性
    var verified_image : UIImage?
    var mbrankImage : UIImage?
    var icon_URL : NSURL?
    var created_Time : String = ""
    var source_Text : String = ""
    var thumbnail_pic : [NSURL]?
    var (itemSize,clvSize) : (CGSize,CGSize) = (CGSizeZero,CGSizeZero)
    var cellHeight : CGFloat = 0
    var identify : String = ""
    var forwardText : String?
    var imageCacheFinish = false
    var cellHeightRight = false
    /// 保存所有配图大图URL
    var bmiddle_pic: [NSURL]?
    
    

    var status : CQStatus
    init(status : CQStatus) {
        self.status = status
        //处理头像
        icon_URL = NSURL(string: status.user?.profile_image_url ?? "")
        // 处理会员图标
        if status.user?.mbrank >= 1 && status.user?.mbrank <= 6 {
            mbrankImage =  UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }else{
            mbrankImage = nil
        }
        
        // 处理认证图片
        switch status.user?.verified_type ?? -1 {
        case 0:
            verified_image = UIImage(named: "avatar_vip")
        case 2,3,5:
            verified_image = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verified_image = UIImage(named: "avatar_grassroot")
        default:
            verified_image = nil
        }
        
        // 处理来源
        if let sourceStr : NSString = status.source where status.source != "" {
            let startIndex = sourceStr.rangeOfString(">").location + 1
            let length = sourceStr.rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
            let str = sourceStr.substringWithRange(NSMakeRange(startIndex, length))
            source_Text = "来自: \(str)"
        }
        
        // 处理时间
        if let timeStr = status.created_at where timeStr != ""{
            let createDate = NSDate.createDate(timeStr, formatterStr: "EE MM dd HH:mm:ss Z yyyy")
            created_Time = createDate.descriptionStr()
        }
        
        identify = ((status.retweeted_status != nil) ? CQforwardCell : CQstatusCell )

        if let pictureS = ((identify == CQstatusCell) ? status.pic_urls : status.retweeted_status?.pic_urls) {

            thumbnail_pic = [NSURL]()
            bmiddle_pic = [NSURL]()
            for dict in pictureS {
                
//                guard let picUrl = NSURL(string: (dict["thumbnail_pic"] as! String)) else{
//                    continue
//                }
                guard var urlStr = dict["thumbnail_pic"] as? String else
                {
                    continue
                }

                thumbnail_pic?.append(NSURL(string: urlStr)!)
                //处理大图
                urlStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
                bmiddle_pic?.append(NSURL(string: urlStr)!)
   
            }
        }
        
        if let text = status.retweeted_status?.text{
            let name = status.retweeted_status?.user?.screen_name ?? ""
            forwardText = "@" + name + ": " + text
        }
        
        super.init()

    }
    
    func cachesImages(finished : (vModle : CQStatusViewModel) -> ()){
            guard let urls = thumbnail_pic else{
                return
            }
            let group = dispatch_group_create()
            for url in urls {
                dispatch_group_enter(group)
                //开始下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue : 0), progress: nil, completed: { (image, error, _, _, _) in
                    dispatch_group_leave(group)
                })
            }
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            (self.itemSize,self.clvSize) =  self.calculateSize()
            self.imageCacheFinish = true
            finished(vModle: self)
        }

    }
    
    private func calculateSize() -> (CGSize,CGSize){
    
        /*
         没有配图: cell = zero, collectionview = zero
         一张配图: cell = image.size, collectionview = image.size
         四张配图: cell = {90, 90}, collectionview = {2*w+m, 2*h+m}
         其他张配图: cell = {90, 90}, collectionview =
         */
        
        let count  = (thumbnail_pic?.count) ?? 0
        if count == 0 {
           return (CGSizeZero,CGSizeZero)
        }
        
        if count == 1 {
            let key = thumbnail_pic?.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            
            return(image.size,image.size)
  
        }
        
        let imageWH : CGFloat = 90.0
        let imageMargin : CGFloat = 10.0
        
        if count == 4 {
            let col  : CGFloat = 2
            let row  : CGFloat = 2
            let w = col * imageWH + (col - 1) * imageMargin
            let h = row * imageWH + (row - 1) * imageMargin
          return (CGSizeMake(imageWH, imageWH),CGSizeMake(w, h))
        }
        
        let col =  3
        let row = (count - 1) / col + 1
        let w = CGFloat(col) * imageWH + (CGFloat(col) - 1) * imageMargin
        let h = CGFloat(row) * imageWH + (CGFloat(row) - 1) * imageMargin
        
       return (CGSizeMake(imageWH, imageWH),CGSizeMake(w, h))
    }

}
