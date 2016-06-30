//
//  CQNewFeatureCollectionViewController.swift
//  CQWB_SWIFT
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
import SnapKit


private let reuseIdentifier = "Cell"

class CQNewFeatureCollectionViewController: UICollectionViewController {
    
    //MARK: - 属性
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    var pageCpunt = 4
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupView()
       
    }
    
   private func setupView()  {
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.registerClass(CQNewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
   private func setupLayout() {
        CQLog(layout)
        layout.itemSize = UIScreen.mainScreen().bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal

    }

  
}

extension CQNewFeatureCollectionViewController {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCpunt
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CQNewFeatureCell
        cell.index = indexPath.item
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let indes = collectionView.indexPathsForVisibleItems().last
        
        let currentCell = collectionView.cellForItemAtIndexPath(indes!) as! CQNewFeatureCell
        if indes?.item == (pageCpunt - 1) {
            
            currentCell.startBtnAnimation()
        }
        

        
    }
    
    
    
}

class CQNewFeatureCell: UICollectionViewCell {
    
    var index : Int = 0 {
        didSet{
            let name = "new_feature_\(index + 1)"
            iconImage.image = UIImage(named: name)
            startBtn.hidden = true
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()

    }

    func setupUI() {
        contentView.addSubview(iconImage)
        contentView.addSubview(startBtn)
        iconImage.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        startBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-160)
        }
    }
    
    func startBtnAnimation() {
        startBtn.hidden = false
        startBtn.transform = CGAffineTransformMakeScale(0, 0)
        startBtn.userInteractionEnabled = false
        UIView.animateWithDuration(2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue : 0), animations: {
            self.startBtn.transform = CGAffineTransformIdentity
            }) { (_) in
                
                self.startBtn.userInteractionEnabled = true
        }

    }

   private lazy var iconImage = UIImageView()
    private lazy var startBtn : UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage.init(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(CQNewFeatureCell.statrtBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    @objc private func statrtBtnClick()  {
           NSNotificationCenter.defaultCenter().postNotificationName(CQSwitchRootViewController, object: true)
        
        
    }
    
    
    
    
    
}









