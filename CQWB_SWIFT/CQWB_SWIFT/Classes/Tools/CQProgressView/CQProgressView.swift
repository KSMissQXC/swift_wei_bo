//
//  CQProgressView.swift
//  CQWB_SWIFT
//
//  Created by apple on 6/22/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class CQProgressView: UIView {
    
    var progress : CGFloat = 0.0{
        didSet{
            //重新绘制
            setNeedsDisplay()
            
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        
        if progress >= 1.0 {
            return
        }
        
        let width = rect.size.width
        let height = rect.size.height
        //中心点
        let corCenter = CGPoint(x: width * 0.5, y: height * 0.5)
        
        //半径
        let radios = min(width * 0.5, height * 0.5)
        
        //开始的角度,结束的角度
        let startAngle = -CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI) * 2 * progress + startAngle
        
        //设置圆的路径
        let circlePath = UIBezierPath(arcCenter: corCenter, radius: radios, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        UIColor(white: 0.8, alpha: 0.5).setFill()
        circlePath.fill()
 
        
    }
    
    
    
    

  
}
