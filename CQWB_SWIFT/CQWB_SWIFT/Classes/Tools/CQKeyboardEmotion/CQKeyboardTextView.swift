//
//  CQKeyboardTextView.swift
//  text_swift表情键盘
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQKeyboardTextView: UITextView {

  
    func insertEmotion(emotion : CQKeyboardEmotion){
        //1.点击的emoj表情
        if let emojiStr = emotion.emoticonStr {
            //获取光标所在的位置
            let selectedRange = selectedTextRange
            //1.用emoj替换所在位置
            replaceRange(selectedRange!, withText: emojiStr)
            return
        }
        
        //2.点击的图片表情
        
        if let pngPath = emotion.pngPath {
            //1.先获取之前的text的属性文字
            let attrM = NSMutableAttributedString(attributedString: attributedText)
            
            //创建点击图片的属性文字
            let attach = CQTextAttachment()
            attach.emoticonChs = emotion.chs
            attach.image = UIImage(contentsOfFile: pngPath)
            attach.bounds = CGRect(x: 0, y: -4, width: (font?.lineHeight)!, height: (font?.lineHeight)!)
            let imageStr = NSAttributedString(attachment: attach)
            
            //获取光标所在位置
            let selectedRange = self.selectedRange
            attrM.replaceCharactersInRange(selectedRange, withAttributedString: imageStr)
            
            //替换textView的属性文字
            attributedText = attrM
            
            //将光标的位置 定在插入后的后面
            self.selectedRange = NSRange.init(location: selectedRange.location + 1, length: 0)
            
            //还原字体
            font = UIFont.systemFontOfSize(18)

        }
    }
    
    
    func emotionStr() -> String {
        let range = NSRange.init(location: 0, length: attributedText.length)
        var strM = String()
        
        attributedText.enumerateAttributesInRange(range, options: NSAttributedStringEnumerationOptions(rawValue : 0)) { (dict, range, _) in
            
            
            if let tempAttachment = dict["NSAttachment"] as? CQTextAttachment{
                strM = strM + tempAttachment.emoticonChs!
            }else{
                strM = strM + (self.text as NSString).substringWithRange(range)
                
            }
            
        }
        
        return strM
        
    }

    
    
    

}
