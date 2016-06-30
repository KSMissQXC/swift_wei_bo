//
//  CQProgressImageView.swift
//  CQWB_SWIFT
//
//  Created by apple on 6/22/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class CQProgressImageView: UIImageView {
    private lazy var progressView : CQProgressView = CQProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    var progress : CGFloat = 0.0{
        didSet{
            progressView.progress = progress
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
   private func setupView()  {
    
        addSubview(progressView)
        progressView.backgroundColor = UIColor.clearColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.frame = bounds

    }
   
    
    
    
    
}
