//
//  CQRefreshControl.swift
//  CQWB_SWIFT
//
//  Created by 耳动人王 on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import SnapKit


class CQRefreshControl: UIRefreshControl {

    //重写init方法
    override init() {
        super.init()
//        self.clipsToBounds = true;
        self.backgroundColor = UIColor.clearColor()
        addSubview(refreshView)
        refreshView.autoresizingMask = UIViewAutoresizing.None
        refreshView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 150, height: 50))
            make.center.equalTo(self)
        }
        
        //监听Fram值的改变
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
        
    }
    
    deinit{
        
        removeObserver(self, forKeyPath: "frame")
    }
    
    override func endRefreshing() {
    
        super.endRefreshing()
        refreshView.stopLoadingView()

        
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        
        if frame.origin.y == 0 || frame.origin.y == -64 {
            return
        }
        
        
        if refreshing {
            refreshView.startLoadingView()
            return
        }
        
        
        if frame.origin.y < -50 && !refreshView.upRotation{
            refreshView.upRotation = true
            refreshView.rotationArrow("up")
        }else if frame.origin.y > -50 && refreshView.upRotation{
            refreshView.upRotation = false
            refreshView.rotationArrow("down")
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  private lazy var refreshView : CQRefreshView = CQRefreshView.refreshView()
    

}

class CQRefreshView: UIView {
    
    /// 菊花
    @IBOutlet weak var loadingImageView: UIImageView!
    /// 提示视图
    @IBOutlet weak var tipView: UIView!
    /// 箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    //是否需要旋转
    var upRotation = false
    
    
   class func refreshView() -> CQRefreshView {
        return NSBundle.mainBundle().loadNibNamed("CQRefreshView", owner: nil, options: nil).last as! CQRefreshView
        
    }
    
    func rotationArrow(rotationDirection : String){
        
        
        var angle = CGFloat(M_PI)
        angle += (rotationDirection.compare("up") == NSComparisonResult.OrderedSame) ? -0.01 : 0.01
         /*
         transform旋转动画默认是按照顺时针旋转的
         但是旋转时还有一个原则, 就近原则
         */
        
        UIView.animateWithDuration(0.25) {
            self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, angle)
        }
    }
    
    /// 显示加载视图
    func startLoadingView(){
        tipView.hidden = true
        
        if loadingImageView.layer.animationForKey("cq") != nil {
            return
        }
        
        let anima = CABasicAnimation(keyPath: "transform.rotation")
        //设置动画属性
        anima.toValue = 2 * M_PI
        anima.duration = 5.0
        anima.repeatCount = MAXFLOAT
        
        
        loadingImageView.layer.addAnimation(anima, forKey: "cq")
    }
    
    
    func stopLoadingView() {
        loadingImageView.layer.removeAllAnimations()
        tipView.hidden = false

    }
    
    
    
    
    
    
}
