//
//  MZCTabBarView.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/20.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCTabBarView: UITabBar {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundImage = UIImage(named: "tabbar_background")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    lazy var button : UIButton = {
        
        let addButton = UIButton(imgName: "tabbar_compose_icon_add", titleString: nil, target: self, action: #selector(MZCTabBarView.centerDidOnclick))
        
        // 设置背景图片
        addButton.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        addButton.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        
        
        self.addSubview(addButton)
        return addButton
    }()
    
    override func layoutSubviews() {

        let w : CGFloat = self.bounds.size.width / 5
        let h : CGFloat = self.bounds.size.height
        
        
        for i in 0..<self.subviews.count {
            let view = self.subviews[i]
            
            var x : CGFloat
            
            if i >= 2{
                x = w * CGFloat(i + 1)
            }else{
                x = w * CGFloat(i)
            }
            
            view.frame = CGRectMake(x, 0.0, w, h)
        }
        
        let buttonX = self.bounds.size.width / 2
        let buttonY = self.bounds.size.height / 2
        self.button.bounds = CGRectMake(0, 0, w, h)
        self.button.center = CGPointMake(buttonX, buttonY)
        
    }
}

extension MZCTabBarView {
    @objc private func centerDidOnclick(){
        
    }
}
