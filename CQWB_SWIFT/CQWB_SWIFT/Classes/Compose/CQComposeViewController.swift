//
//  CQComposeViewController.swift
//  CQWB_SWIFT
//
//  Created by apple on 6/23/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit
import SVProgressHUD


class CQComposeViewController: UIViewController {
//MARK: - 属性
    @IBOutlet weak var sendItem: UIBarButtonItem!
    
    @IBOutlet weak var toolBarlBottomDistance: NSLayoutConstraint!
    @IBOutlet weak var textView: CQComposeTextView!
    ///键盘控制器
    var keyboardVC = CQKeyboardViewController()
    
    @IBOutlet weak var containViewHeight: NSLayoutConstraint!
    
    var photoVc : CQPhotoPickerCollectionViewController?
    

    
    
//MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CQComposeViewController.keyboardFrameChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CQComposeViewController.emotionKeyboardClick(_:)), name: "addEmotion", object: nil)

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if containViewHeight.constant == 10 {
            textView.becomeFirstResponder()

        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "photoPicker" {
            
            photoVc = segue.destinationViewController as? CQPhotoPickerCollectionViewController
            
        }
    }
    
    
    
    
    //MARK: - 事件处理
    @IBAction func closeClick(sender: AnyObject?) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendClick(sender: AnyObject) {
        
        //取出图片
        let image = photoVc?.images.last
        let statusText = textView.emotionStr()
        
        // 3.提醒用户正在发送微博
        SVProgressHUD.showWithStatus("正在发送微博", maskType: SVProgressHUDMaskType.Black)
        
        // 4.退出键盘
        textView.resignFirstResponder()

        
        //发送微博
        CQNetWorkTools.shareInstance.sendStatus(statusText, image: image) { (objc, error) in
            
            if error != nil{
                
                // 提醒用户发送微博失败
                SVProgressHUD.showInfoWithStatus("发送微博失败", maskType: SVProgressHUDMaskType.Black)
                
                return

            }
            
            if objc != nil{
                // 提醒用户发送微博成功
                SVProgressHUD.showInfoWithStatus("发送微博成功", maskType: SVProgressHUDMaskType.Black)
                
                // 退出控制器
                self.dismissViewControllerAnimated(true, completion: nil)

            }
            
            
            
        }
        
        
    }
    
    @objc func keyboardFrameChange(noti:NSNotification){
        
//        CQLog(noti)
        // 1.获取键盘的frame
        let rect = noti.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        // 3.计算需要移动的距离
        let offsetY = CQheight - rect.origin.y
        toolBarlBottomDistance.constant = offsetY
        UIView.animateWithDuration(0.25) {
            // 如果执行多次动画,则忽略上一次已经未完成的动画,直接进入下一次
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            self.view.layoutIfNeeded()
        }

    }
    
    
    @IBAction func emotionBtnClick(sender: UIBarButtonItem) {
        
        textView.resignFirstResponder()
        //切换键盘
        if textView.inputView == nil {
            textView.inputView = keyboardVC.view
        }else{
            textView.inputView = nil
        }
        textView.becomeFirstResponder()
    }
    
    
    @IBAction func photoClick(sender: UIBarButtonItem) {
        
        containViewHeight.constant = CQheight * 0.7
        
        UIView.animateWithDuration(0.4) { 
            self.view.layoutIfNeeded()
        }
        
        //退出键盘
        textView.resignFirstResponder()

    }
    
    
    
    
    @objc func emotionKeyboardClick(notice : NSNotification){
        
        guard let emotion = notice.userInfo!["emotion"] as? CQKeyboardEmotion else{
            return
        }
        
     
        
        textView.insertEmotion(emotion)
        
        
        //3.点击的删除按钮
        if emotion.isRemoveButton {
            textView.deleteBackward()
        }
        //手动调用文字改变
        textViewDidChange(textView)
        
    }

    
    
    
    
    

}

//MARK: - 代理
extension CQComposeViewController : UITextViewDelegate,UIScrollViewDelegate{
    
    func textViewDidChange(textView: UITextView) {
        sendItem.enabled = textView.hasText()
        (textView as! CQComposeTextView).placeholderLabel.hidden = textView.hasText()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
    
}





