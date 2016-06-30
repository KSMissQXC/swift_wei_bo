//
//  CQQRViewController.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import AVFoundation

class CQQRViewController: UIViewController {
//MARK: - 属性
    @IBOutlet weak var customTabBar: UITabBar!
    
    @IBOutlet weak var topDistance: NSLayoutConstraint!
    
    @IBOutlet weak var contanierHeight: NSLayoutConstraint!
    @IBOutlet weak var contanierWidth: NSLayoutConstraint!
    
    @IBOutlet weak var scanLineView: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var contanierView: UIView!
    
    //MARK: 懒加载
    /// 输入对象
    private lazy var input : AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device:device)
    }()
    
    /// 会话
    private lazy var session : AVCaptureSession = AVCaptureSession()
    /// 输出对象
    private lazy var output : AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        // 设置输出对象解析数据时感兴趣的范围
        // 默认值是 CGRect(x: 0, y: 0, width: 1, height: 1)
        // 通过对这个值的观察, 我们发现传入的是比例
        // 注意: 参照是以横屏的左上角作为, 而不是以竖屏
        //        out.rectOfInterest = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
        
        // 1.获取屏幕的frame
        self.view.layoutIfNeeded()
        let viewRect = self.view.frame
        // 2.获取扫描容器的frame
        let containerRect = self.contanierView.frame
        let x = containerRect.origin.y / viewRect.height;
        let y = containerRect.origin.x / viewRect.width;
        let width = containerRect.height / viewRect.height;
        let height = containerRect.width / viewRect.width;
        
        out.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        return out

    }()
    private lazy var previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session:self.session)
    private lazy var containerLayer = CALayer()

    

    
//MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        customTabBar.selectedItem = customTabBar.items![0]
        scanQRCode()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        startAaimation()

    }
    
//MARK: 开始动画
    private func startAaimation(){
        topDistance.constant = -self.contanierHeight.constant
        view.layoutIfNeeded()
        UIView.animateWithDuration(2) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.topDistance.constant = self.contanierHeight.constant
            self.view.layoutIfNeeded()
        }
    }
    //MARK: 开启二维码扫描
   private func scanQRCode() {
    if !session.canAddInput(input) {
        return
    }
    
    if !session.canAddOutput(output) {
        return
    }
    
    session.addInput(input)
    session.addOutput(output)
    
    output.metadataObjectTypes = output.availableMetadataObjectTypes
    
    output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
    view.layer.insertSublayer(previewLayer, atIndex: 0)
    previewLayer.frame = view.bounds
    
    // 7.添加容器图层
    view.layer.addSublayer(containerLayer)
    containerLayer.frame = view.bounds
    
    
    session.startRunning()

    }


    
//MARK: - 事件处理
    
    @IBAction func disMissClick(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func photoClick(sender: AnyObject) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            return
        }
        
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.delegate = self
        presentViewController(imagePickerVc, animated: true, completion: nil)
        
        
        
    }
    
    

  
}

//MARK: 代理
extension CQQRViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            return
        }
        
        guard let ciImage = CIImage(image: image) else{
            return
        }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let results = detector.featuresInImage(ciImage)
        for result in results {
            CQLog((result as! CIQRCodeFeature).messageString)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    
}


extension CQQRViewController : UITabBarDelegate{
     func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem){
        contanierHeight.constant = (item.tag == 1) ? 150 : 200
        view.layoutIfNeeded()
        scanLineView.layer.removeAllAnimations()
        startAaimation()

    }
}

extension CQQRViewController : AVCaptureMetadataOutputObjectsDelegate{
     func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        contentLabel.text = metadataObjects.last?.stringValue
        clearLayers()
        
        guard let metadata = metadataObjects.last as? AVMetadataObject else{
            return
        }
        
        
        let  objc = previewLayer.transformedMetadataObjectForMetadataObject(metadata)
        
        drawLines(objc as! AVMetadataMachineReadableCodeObject)
        
    }
    
   private func clearLayers(){
    guard let subLayers = containerLayer.sublayers else{
        return
    }
    for layer in subLayers {
        layer.removeFromSuperlayer()
    }
    
    }
    
    func drawLines(objc : AVMetadataMachineReadableCodeObject) {
        
        guard let array = objc.corners else{
            return
        }
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.greenColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        let path = UIBezierPath()
        var point = CGPointZero
        
        for i in 0..<array.count {
            CGPointMakeWithDictionaryRepresentation(array[i] as! CFDictionary, &point)
            if i == 0 {
                path.moveToPoint(point)
            }else{
                path.addLineToPoint(point)
            }
        }
        
        path.closePath()
        layer.path = path.CGPath
        
        containerLayer.addSublayer(layer)
        
    }

}





















