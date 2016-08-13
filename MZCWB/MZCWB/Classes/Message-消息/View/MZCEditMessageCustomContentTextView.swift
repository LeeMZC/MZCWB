//
//  MZCMessageTextView.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/12.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

class MZCEditMessageCustomContentTextView: UITextView {
    //MARK:- lazy
    private lazy var placeholderLabel : UILabel = {
        let label = UILabel()
        label.text = "分享新鲜事..."
        label.tintColor = UIColor.grayColor()
        label.font = self.font
        label.sizeToFit()
        return label
    }()
    
    
    //MARK:- 生命周期
    override func awakeFromNib() {
        setupUI()
    }
    /** 布局子控件 */
    override func layoutSubviews() {
        placeholderLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(4)
            make.top.equalTo(self).offset(8)
        }
    }
    /** 销毁通知 */
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

//MARK:- private
extension MZCEditMessageCustomContentTextView {
    /** setupUI */
    private func setupUI(){
        setupNotf()
        addSubview(placeholderLabel)
        
    }
    /** 通知内容改变 */
    private func setupNotf(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MZCEditMessageCustomContentTextView.textViewDidChange), name: UITextViewTextDidChangeNotification, object: nil)
    }
}

//MARK:- event
extension MZCEditMessageCustomContentTextView {
    @objc private func textViewDidChange(){
        placeholderLabel.hidden = self.hasText()
    }
}