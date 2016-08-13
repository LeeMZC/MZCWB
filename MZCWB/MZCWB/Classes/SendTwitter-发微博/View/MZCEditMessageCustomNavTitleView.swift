//
//  MZCMessageTitleView.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/11.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import SnapKit
/// 上titleFont
private let MZCUpLabelFont : UIFont = UIFont.systemFontOfSize(20)
/// 下titleFont
private let MZCBottomFont : UIFont = UIFont.systemFontOfSize(12)
/// self 高度
private let MZCTitleViewH : CGFloat = 44

class MZCEditMessageCustomNavTitleView: UIView {
    //MARK:- lazy
    private lazy var upLabel : UILabel = {
        let label = UILabel()
        label.text = "发送微博"
        label.tintColor = UIColor.blackColor()
        label.font = MZCUpLabelFont
        label.textAlignment = NSTextAlignment.Center
        label.sizeToFit()
        return label
    }()
    
    private lazy var bottomLabel : UILabel = {
        let label = UILabel()
        label.text = "MZC"
        label.tintColor = UIColor.blackColor()
        label.font = MZCBottomFont
        label.textAlignment = NSTextAlignment.Center
        label.sizeToFit()
        return label
    }()
    
    //MARK:- 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
    
        upLabel.snp_makeConstraints { (make) in
            make.left.top.equalTo(self)
            make.centerX.equalTo(self)
            
        }
        
        bottomLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(upLabel.snp_bottom)
            make.centerX.equalTo(self)
        }
    }
}
//MARK:- private
extension MZCEditMessageCustomNavTitleView {
    private func setupUI(){
        addSubview(upLabel)
        addSubview(bottomLabel)
        self.frame = CGRectMake(0, 0, MZCScreenSize.width, MZCTitleViewH)
    }
}

