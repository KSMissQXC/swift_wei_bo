//
//  CQKeyboardViewController.swift
//  text_swift表情键盘
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CQKeyboardViewController: UIViewController {
//MARK: - 属性
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: CQKeyboardEmoticonLayout!
    
    
    
    
    
//MARK: - 初始化
   override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CQKeyboardViewController.addEmotion(_:)), name: "addEmotion", object: nil)
    }
    
    
    @objc func addEmotion(notice : NSNotification){
        
        
        if notice.object as! Bool {
            let emotion = notice.userInfo!["emotion"] as! CQKeyboardEmotion
            CQKeyboardPackage.packages[0].addFavoriteEmoticon(emotion)
        }
        
      
        
        
    }
    
    private func setupView() {
        collectionView.registerNib(UINib.init(nibName: "CQKeyboardEmotionCell", bundle: nil), forCellWithReuseIdentifier: "emotionCell")

    }
 
//MARK: - 事件处理
    @IBAction func itemClick(sender: UIBarButtonItem) {
        
        collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: 0, inSection: sender.tag), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        
    }

}

extension CQKeyboardViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return CQKeyboardPackage.packages.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (CQKeyboardPackage.packages[section].emoticons.count / 21)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emotionCell", forIndexPath: indexPath) as! CQKeyboardEmotionCell
        
        
        let package = CQKeyboardPackage.packages[indexPath.section]
        
        let range = NSRange.init(location: indexPath.item * 21, length: 21)
        let subEmotionArray = (package.emoticons as NSArray).subarrayWithRange(range)
        cell.emotions = subEmotionArray as? [CQKeyboardEmotion]
        return cell
    }
    
}




class CQKeyboardEmoticonLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        //这里拿到的collectionView的frame才是准确的
        // 1.计算cell宽度
        let width = collectionView?.bounds.width
        let height = collectionView?.bounds.height

        itemSize = CGSize(width: width!, height: height!)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 2.设置collectionView
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}

















