//
//  MZCNoMoreDataTipsView.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/6.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

class MZCNoMoreDataTipsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    let aniDuration = 1.0
    let aniDelay = 2.0
    
    private lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.text = "没有更多提示"
        label.frame = self.bounds
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(20)
        self.addSubview(label)
        
        return label
    }()
    
    private func setupUI(){
        backgroundColor = UIColor.greenColor()
        hidden = true
    }
    
    func ani(count : Int){
        
        if hidden == false {return }
        
        tipsLabel.text = count == 0 ? "没有更多数据" : "加载\(count)条"
        
        let x = self.frame.origin.x
        let y = self.bounds.height
        hidden = false
        
        UIView.animateWithDuration(aniDuration, animations: {
            self.transform = CGAffineTransformMakeTranslation(x, y)
            }) { (_) in
                
                UIView.animateWithDuration(self.aniDuration, delay: self.aniDelay, options:
                    UIViewAnimationOptions(rawValue: 0), animations: {
                    
                        self.transform = CGAffineTransformIdentity
                    
                    }, completion: { (_) in
                        self.hidden = true
                })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
