//
//  CQComposeTextView.swift
//  CQWB_SWIFT
//
//  Created by apple on 6/23/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit
import SnapKit


class CQComposeTextView: CQKeyboardTextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
        
    }
    
   private func setupView()  {
        addSubview(placeholderLabel)
        placeholderLabel.snp_makeConstraints { (make) in
            make.left.equalTo(4)
            make.top.equalTo(8)
     }
    
//    NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(CQComposeTextView.textDidChange) , name: UITextViewTextDidChangeNotification, object: self)

    
}
    
//    @objc func textDidChange(){
//        
//        placeholderLabel.hidden = hasText()
//
//    }
    
    lazy var placeholderLabel : UILabel = {
    
        let placeLabel = UILabel()
        placeLabel.text = "分享新鲜事..."
        placeLabel.textColor = UIColor.grayColor()
        placeLabel.font = self.font
        return placeLabel
    }()
    
    
    
    
    

    
    
    
  
}
