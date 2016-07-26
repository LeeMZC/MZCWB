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
        
        setupNotificationCenter()
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupNotificationCenter(){
        // 3.注册通知
        MZCNSNotificationCenterMessage.shareInstance.homeTitleButtonDidChange(self, selector: #selector(MZCHomeTitleButton.titleChange))
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
    
    func imgAnimation(){
        guard let tempImgView = imageView else{
            return
        }
        
        selected = !selected
        let timer = 0.5
        if selected {
            UIView.animateWithDuration(timer, animations: {
                tempImgView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            })
        }else{
            UIView.animateWithDuration(timer, animations: {
                tempImgView.transform = CGAffineTransformIdentity
            })
        }
    }
    
    func titleChange(){
        imgAnimation()
    }
    
    deinit{
        // 移除通知
        MZCNSNotificationCenterMessage.shareInstance.removeObserver(self)
    }
}
