//
//  CQPhotoPickerCollectionViewController.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CQPhotoPickerCollectionViewController: UICollectionViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //MARK: - 属性
    ///存放保存的图片
    var images = [UIImage]()
    

    
    
    //MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()


    }


    //MARK: - 代理
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CQPhotoPickerCell
        cell.image = (indexPath.item >= images.count) ? nil : images[indexPath.item]
        cell.addImageClick = {
            //弹出照片 选择控制器
            guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) else{
                CQLog("照片不可用")
                return
            }
            let pc = UIImagePickerController()
            pc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            pc.delegate = self
            self.presentViewController(pc, animated: true, completion: nil)
        }
        
        cell.removeImageClick = {
            self.images.removeAtIndex(indexPath.item)
            self.collectionView?.reloadData()
        }
        
        
        

        return cell
    }
    
    
     func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        // 1.获取选择的照片
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        // 2.退出控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let newImage = drawImage(image, width: 450)

        images.append(newImage)
        
        //刷新表格
        collectionView?.reloadData()

    }
    
    
    func drawImage(image : UIImage,width : CGFloat) -> UIImage {
        //获取需要绘制的图片的尺寸
        let height = (image.size.height / image.size.width) * width
        let size = CGSize(width: width, height: height)
        //开启图片上下午
        UIGraphicsBeginImageContext(size)
        
        //将图片画到上下午
        image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        //从上下午中获取图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage

        
    }
    
    
    
    
}


//MARK: - 自定义collectionViewCell
class CQPhotoPickerCell : UICollectionViewCell{
    
    @IBOutlet weak var bgImageView: UIButton!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    var addImageClick : (() -> ())?
    var removeImageClick : (() -> ())?

    var image : UIImage?{
        didSet{
            if image == nil {
                bgImageView.setBackgroundImage(UIImage(named:"compose_pic_add" ), forState: UIControlState.Normal)
                bgImageView.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
                bgImageView.userInteractionEnabled = true
                removeBtn.hidden = true
            }else{
                bgImageView.setBackgroundImage(image, forState: UIControlState.Normal)
                bgImageView.userInteractionEnabled = false
                removeBtn.hidden = false
            }
            
            
            
        }
    }
    
    
    
    @IBAction func addImageClick(sender: AnyObject) {
        
        addImageClick!()
        
    }
    
    
    
    @IBAction func removeBtnClick(sender: UIButton) {
        
        removeImageClick!()
    }
    
    
    
    
    
}




//MARK: - 重写collectionView的布局
class CQPhotoPickerFlowlayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        //1.定义常量
        let margin : CGFloat = 20
        let col : CGFloat = 3
        
        let itemWH = ((collectionView?.bounds.width)! - margin * (col + 1)) / col
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = margin
        minimumInteritemSpacing = margin
        
        sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin)

        
    }
}





