//
//  CQVisitorView.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQVisitorView: UIView {

  
    @IBOutlet weak var registerBtn: UIButton!
    /// 登录按钮
    @IBOutlet weak var loginBtn: UIButton!
    /// 旋转视图
    @IBOutlet weak var rotationView: UIImageView!
    /// 大图标视图
    @IBOutlet weak var iconView: UIImageView!
    /// 标题视图
    @IBOutlet weak var titleView: UILabel!
    
//MARK: - 初始化方法
  class func visitorView() -> CQVisitorView {
            return NSBundle.mainBundle().loadNibNamed("CQVisitorView", owner: nil, options: nil).last as! CQVisitorView
    }
    
//MARK: - 外界调用设置属性
    func setupVisitorViewInfo(imageName : String? ,title : String){
        titleView.text = title
        guard let name = imageName else{
            startAnimation()
            return
        }
        rotationView.hidden = true
        iconView.image = UIImage(named: name)
        
    }

    
//MARK: - 私有方法
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.removedOnCompletion = false
        anim.duration = 5
        rotationView.layer.addAnimation(anim, forKey: nil)

    }
    

    
    
    
}
