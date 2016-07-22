//
//  MZCHomeTitleButton.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/21.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCHomeTitleButton: UIButton {
    
    private let spacing = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI(){
        
        self.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Normal)
        self.setTitle("MZC", forState: UIControlState.Normal)
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.sizeToFit()
        self.frame.size.width += (CGFloat)(spacing)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame.origin.x = 0.0
        imageView?.frame.origin.x = (titleLabel?.frame.size.width )! + (CGFloat)(spacing / 2)
    }
}
