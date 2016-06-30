//
//  CQKeyboardEmotionCell.swift
//  text_swift表情键盘
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQKeyboardEmotionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var emotions :[CQKeyboardEmotion]?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.registerNib(UINib.init(nibName: "CQEmotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cqCell")
        
    }
    

}


extension CQKeyboardEmotionCell : UICollectionViewDataSource,UICollectionViewDelegate{

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cqCell", forIndexPath: indexPath) as! CQEmotionCollectionViewCell
        cell.emoticon = emotions![indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var notAddBtn = false
        
        
        let emotion =  emotions![indexPath.item]
        if !emotion.isRemoveButton {
            emotion.count = emotion.count + 1
            notAddBtn = true

        }
        NSNotificationCenter.defaultCenter().postNotificationName("addEmotion", object: notAddBtn, userInfo: ["emotion" : emotion])

    }
    

    
    
    
    
    
}



class CQKeyboardLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        super.prepareLayout()
        // 1.计算cell宽度
        let width = UIScreen.mainScreen().bounds.width / 7
        let height = collectionView!.bounds.height / 3
        
        itemSize = CGSize(width: width, height: height)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Vertical
        // 2.设置collectionView
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        print(collectionView?.frame)

    }

}


















