//
//  UIButton+MZCExtension.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/21.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

extension UIButton{
    convenience init(imgName:String , titleString : String?, target: AnyObject?, action: Selector){
        self.init()
        self.setImage(UIImage.init(named: imgName), forState: UIControlState.Normal)
        self.setImage(UIImage.init(named: imgName + "_highlighted"), forState: UIControlState.Highlighted)
        
        if target != nil {
            self.addTarget(target!, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        if titleString != nil {
            titleLabel?.text = titleString
        }
        
    }
}
