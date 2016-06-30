//
//  CQEmotionCollectionViewCell.swift
//  text_swift表情键盘
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQEmotionCollectionViewCell: UICollectionViewCell {

    /// 当前行对应的表情模型
    var emoticon : CQKeyboardEmotion?{
        didSet{
            // 1.显示emoji表情
            iconBtn.setTitle(emoticon?.emoticonStr ?? "", forState: UIControlState.Normal)
            
            // 2.设置图片表情
            iconBtn.setImage(nil, forState: UIControlState.Normal)
            if emoticon?.chs != nil
            {
                iconBtn.setImage(UIImage(contentsOfFile: emoticon!.pngPath!), forState: UIControlState.Normal)
            }
            
            // 3.设置删除按钮
            if emoticon!.isRemoveButton
            {
                iconBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                iconBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    @IBOutlet weak var iconBtn: UIButton!


}
