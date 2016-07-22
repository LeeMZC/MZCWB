//
//  UIBarButtonItem+MZCExtension.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/21.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imgName:String , target: AnyObject?, action: Selector){
        let btn = UIButton()
        btn.setImage(UIImage(named: imgName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imgName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        self.init(customView: btn)
    }
}