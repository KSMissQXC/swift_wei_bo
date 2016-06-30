//
//  NSDate+CQExtension.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

extension NSDate{
    class func createDate(timeStr : String,formatterStr : String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = formatterStr
        formatter.locale = NSLocale(localeIdentifier: "en")
        return formatter.dateFromString(timeStr)!
    }
    
    func descriptionStr() -> String {
      
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en")
        let calendar = NSCalendar.currentCalendar()
        
        var formatterStr = "HH:mm"
        var showTime = ""
        if calendar.isDateInToday(self) {
            
            let timeInterval = Int(NSDate().timeIntervalSinceDate(self))
            
            if timeInterval < 60 {
                showTime = "刚刚"

            }else if timeInterval < 60 * 60{
                showTime = "\(timeInterval / 60)分钟前"
            }else{
                showTime = "\(timeInterval / (60 * 60))小时前"
            }
            return showTime

        }else if calendar.isDateInYesterday(self){
            formatterStr = "昨天" + formatterStr
            //                    formatter.dateFormat = formatterStr
            //                    showTime = formatter.stringFromDate(createData)
        }else{
            
            let comps = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue : 0))
            //非今年
            if comps.year >= 1 {
                formatterStr = "yyyy-MM-dd " + formatterStr
                
            }else{
                formatterStr = "MM-dd " + formatterStr
            }
        }
        formatter.dateFormat = formatterStr
        showTime = formatter.stringFromDate(self)
        return showTime
    }

    
    
    
    






}

