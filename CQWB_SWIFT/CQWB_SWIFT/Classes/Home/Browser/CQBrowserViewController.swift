//
//  CQBrowserViewController.swift
//  CQWB_SWIFT
//
//  Created by apple on 6/21/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD




class CQBrowserViewController: UIViewController {
//MARK: - 属性
    /// 所有配图
    var bmiddle_pic : [NSURL]
    /// 当前点击的索引
    var indexPath: NSIndexPath
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    ///保存需要数据的模型
    var presentModel : CQPresentModel?
    
    
    
    
    
//MARK: - 初始化
    init(bmiddle_pic : [NSURL],indexPath : NSIndexPath){
        self.bmiddle_pic = bmiddle_pic
        self.indexPath = indexPath
        super.init(nibName: "CQBrowserViewController", bundle: nil)
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

    }
    
    //设置初始化属性
    func setup(){
        flowLayout.itemSize = UIScreen.mainScreen().bounds.size
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView.pagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.registerClass(CQBorwserCell.self, forCellWithReuseIdentifier: "borwserCell")
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    

    //MARK: - 事件处理

    @IBAction func closeClick(sender: AnyObject) {
        let index = collectionView.indexPathsForVisibleItems().last
        let cell = getCurrentShowCell()

        NSNotificationCenter.defaultCenter().postNotificationName(ChangePresentModel, object: self, userInfo: [CQbrowserModel : presentModel!,CQindexPath : index!,CQImage : cell.imageView.image!])

        dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    //MARK: 保存照片
    @IBAction func saveClick(sender: AnyObject) {
        
        //获取当前屏幕显示的cell
        let cell = getCurrentShowCell()
        let image = cell.imageView.image
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(CQBrowserViewController.saveFinish(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    //MARK: 获取当前屏幕显示的cell
    func getCurrentShowCell() -> CQBorwserCell {
        let index = collectionView.indexPathsForVisibleItems().last
        let cell = collectionView.cellForItemAtIndexPath(index!) as! CQBorwserCell
        return cell
    }

    
    
    
    
    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
   @objc func saveFinish(image : UIImage,didFinishSavingWithError : NSError?,contextInfo : AnyObject?)  {
        if didFinishSavingWithError != nil {
            SVProgressHUD.showErrorWithStatus("保存图片失败", maskType: SVProgressHUDMaskType.Black)
            return
        }
        SVProgressHUD.showSuccessWithStatus("保存图片成功", maskType: SVProgressHUDMaskType.Black)

    }



}


extension CQBrowserViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bmiddle_pic.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("borwserCell", forIndexPath: indexPath) as! CQBorwserCell
        cell.imageUrl = bmiddle_pic[indexPath.item]
        return cell
    }

}



class CQBorwserCell: UICollectionViewCell ,UIScrollViewDelegate{
    
    var imageUrl : NSURL?{
        didSet{
            
            // 重置容器所有数据
            resetView()
            indicatorView.startAnimating()
            
            imageView.sd_setImageWithURL(imageUrl) { (image, error, _, url) in
                //计算图片的比例
                self.indicatorView.stopAnimating()
                let sacle = image.size.height / image.size.width
                let imageHeight = sacle * CQwidth
                self.imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: CQwidth, height: imageHeight))
                if imageHeight > CQheight {
                    self.scrollview.contentSize = CGSizeMake(CQwidth, imageHeight)
                }else{
                    let offsetY = (CQheight - imageHeight) * 0.5
                    self.scrollview.contentInset = UIEdgeInsetsMake(offsetY, 0, offsetY, 0)
                    
                }
                
            }
            
        }
    }
    
   private func resetView()  {
    
        scrollview.contentInset = UIEdgeInsetsZero
        scrollview.contentSize = CGSizeZero
        scrollview.contentOffset = CGPointZero
        imageView.transform = CGAffineTransformIdentity
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        //宽度方向的偏移量(这里只能根据frame来计算,通过bounds拿到的值不准确)
        var offsetX = CQwidth - imageView.frame.size.width
        
        //高度方向的偏移量
        var offsetY = CQheight - imageView.frame.size.height
        
        //偏移量修正
        offsetX = (offsetX < 0 ? 0 : offsetX)
        offsetY = (offsetY < 0 ? 0 : offsetY)
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX)
        
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollview)
        contentView.addSubview(indicatorView)
        indicatorView.center = contentView.center
        scrollview.frame = CGRectMake(0, 0,UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        scrollview.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private lazy var scrollview : UIScrollView = {
        let sc = UIScrollView()
        sc.delegate = self
        sc.maximumZoomScale = 2.0
        sc.minimumZoomScale = 0.5
        return sc
    }()
    private lazy var imageView : UIImageView = UIImageView()
    
    //提示视图
   private lazy var indicatorView : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    

}












