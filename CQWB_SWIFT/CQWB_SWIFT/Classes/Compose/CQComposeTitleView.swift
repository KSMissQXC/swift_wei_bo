//
//  CQComposeTitleView.swift
//  CQWB_SWIFT
//
//  Created by apple on 6/23/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit
import SnapKit

class CQComposeTitleView: UIView {
//MARK: - 属性
  private  lazy var titleLable : UILabel = {
    
        let tLabel = UILabel()
        tLabel.font = UIFont.systemFontOfSize(18)
        tLabel.text = "发送微博"
        tLabel.textColor = UIColor.orangeColor()
        return tLabel
    }()
    
    private  lazy var subLabel : UILabel = {
        let tLabel = UILabel()
        tLabel.font = UIFont.systemFontOfSize(15)
        tLabel.text = CQUserAccount.account?.screen_name ?? ""
        tLabel.textColor = UIColor.grayColor()
        return tLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()

        
    }
    
   private func setupView()  {
    
        addSubview(titleLable)
        addSubview(subLabel)
        titleLable.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            if subLabel.text == ""{
                make.centerY.equalTo(self)
                return
            }else{
                make.top.equalTo(self.snp_top)
            }
        }
    
        subLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLable.snp_bottom)

       }
    }
    
  
}
