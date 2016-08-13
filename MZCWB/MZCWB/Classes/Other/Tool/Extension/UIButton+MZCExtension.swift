//
//  UIButton+MZCExtension.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/21.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

extension UIButton{
    convenience init(imgName : String? , titleString : String?, target: AnyObject?, action: Selector){
        self.init()
        
        if let tempImgName = imgName {
            self.setImage(UIImage.init(named: tempImgName), forState: UIControlState.Normal)
            self.setImage(UIImage.init(named: tempImgName + "_highlighted"), forState: UIControlState.Highlighted)
        }
        
        if let tempTitleString = titleString {
            setTitle(tempTitleString, forState: UIControlState.Normal)
            setTitle(tempTitleString, forState: UIControlState.Highlighted)
        }
        
        
        self.addTarget(target!, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
}
