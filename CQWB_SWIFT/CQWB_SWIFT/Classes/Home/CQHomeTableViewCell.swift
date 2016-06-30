//
//  CQHomeTableViewCell.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import SDWebImage
import KILabel


class CQHomeTableViewCell: UITableViewCell {
//MARK: - 属性
    /// 配图视图
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    /// 配图布局对象
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    /// 配图高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    // 配图宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    
    /// 头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var vipImageView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var contentLabel: KILabel!
    /// 底部视图
    @IBOutlet weak var footerView: UIView!
    
    /// 转发正文
    @IBOutlet weak var forwardLabel: KILabel!
    
    var status : CQStatusViewModel?{
        didSet{
            // 1.设置头像
            iconImageView.sd_setImageWithURL(status?.icon_URL)
            // 2.设置认证图标
            verifiedImageView.image = status?.verified_image

            // 3.设置昵称
            nameLabel.text = status?.status.user?.screen_name
            
            // 4.设置会员图标
            vipImageView.image = status?.mbrankImage
            nameLabel.textColor = status?.mbrankImage != nil ? UIColor.redColor() : UIColor.blackColor()
         
            // 5.设置时间
            timeLabel.text = status?.created_Time

            // 6.设置来源
            sourceLabel.text = status?.source_Text
            
            // 7.设置正文
            contentLabel.attributedText = CQKeyboardPackage.createMutableAttrString((status?.status.text) ?? "", font: contentLabel.font)
            if let forwardText = status?.forwardText {
                forwardLabel.attributedText = CQKeyboardPackage.createMutableAttrString(forwardText, font: forwardLabel.font)
            }
            pictureCollectionView.reloadData()
            
            if status?.itemSize != CGSizeZero {
                flowLayout.itemSize = (status?.itemSize)!;
            }
            
            pictureCollectionViewHeightCons.constant = (status?.clvSize.height)!
            pictureCollectionViewWidthCons.constant = (status?.clvSize.width)!
           
            if status!.cellHeight == 0{
                layoutIfNeeded()
                status?.cellHeight = CGRectGetMaxY(footerView.frame)
            }

            
            if status!.imageCacheFinish && !status!.cellHeightRight{

                layoutIfNeeded()
                status?.cellHeight = CGRectGetMaxY(footerView.frame)
                status?.cellHeightRight = true
            }

        }

    }
    
    
    //MARK: - 初始化
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 20;
        // 监听@了谁
        contentLabel.userHandleLinkTapHandler = { label, handle, range in
            print("\(handle) \(range)")
        }
        
        // 监听话题的点击
        contentLabel.hashtagLinkTapHandler = { label, hashtag, range in
            print("\(hashtag) \(range)")
        }
        
        // 监听连接的点击
        contentLabel.urlLinkTapHandler = { label, url, range in
            print("\(url) \(range)")
        }

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CQHomeTableViewCell.changePresentModle(_:)), name:ChangePresentModel , object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CQHomeTableViewCell.changePresentModle(_:)), name: ChangePresentModel, object: nil)
        

        
        if reuseIdentifier == CQforwardCell {
            forwardLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 20;
        }

    }
    
   @objc func changePresentModle(notice : NSNotification) {

        let model = notice.userInfo![CQbrowserModel] as! CQPresentModel
    //过滤掉不需要监听的collectionView
    if model.collectionView != pictureCollectionView {
        return
    }
        let indexPath = notice.userInfo![CQindexPath] as! NSIndexPath
        let image = notice.userInfo![CQImage] as! UIImage
        getPresentModel(indexPath, collectionView: pictureCollectionView, image: image, model: model)
 
    }
    
 
}

//MARK: - collectionView的数据源和代理
extension CQHomeTableViewCell :UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return status?.thumbnail_pic?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! CQHomePictureCell
        cell.url = status?.thumbnail_pic![indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //获取点击的url
        let url = status?.bmiddle_pic![indexPath.item]
        
        //拿到点击的cell
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CQHomePictureCell
        
        //开始下载图片
        SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue : 0), progress: { (current, total) in
            cell.customIconImageView.progress = (CGFloat(current) / CGFloat(total))

            }) { (image, error, _, _, _) in
                //弹出图片轮播器,并传出转场动画需要的模型
                
                let model = CQPresentModel()
                self.getPresentModel(indexPath, collectionView: collectionView, image: image, model: model)
                NSNotificationCenter.defaultCenter().postNotificationName(CQShowPhotoBrowserController, object: collectionView, userInfo: [CQbmiddle_pic: self.status!.bmiddle_pic!, CQindexPath: indexPath,CQbrowserModel :model])
        }

    }
    
    //MARK:  获取点击图片时转场动画需要的模型
   func getPresentModel(indexPath : NSIndexPath,collectionView : UICollectionView,image : UIImage,model : CQPresentModel) {
        //根据索引拿到点击的cell可以获得图片
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CQHomePictureCell
        model.image = image
        model.oldFrame = cell.frame
        
        model.collectionView = collectionView
        model.newFrame = collectionView.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
    
        //获得当前图片的比例
        let scale = (model.image?.size.height)! / (model.image?.size.width)!
        let imageHeight = scale * CQwidth
        var offsetY : CGFloat = 0
        if imageHeight < CQheight {
            offsetY = (CQheight - imageHeight) * 0.5
        }
        model.toFrame =  CGRect(x: 0, y: offsetY, width: CQwidth, height: imageHeight)
    }
    
}

class CQHomePictureCell: UICollectionViewCell {
    var url : NSURL?{
        didSet{
            customIconImageView.sd_setImageWithURL(url)
            if let flag = url?.absoluteString.lowercaseString.hasSuffix("gif") {
                gifImageView.hidden = !flag
            }

        }
    }


    @IBOutlet weak var customIconImageView: CQProgressImageView!

    @IBOutlet weak var gifImageView: UIImageView!

}








