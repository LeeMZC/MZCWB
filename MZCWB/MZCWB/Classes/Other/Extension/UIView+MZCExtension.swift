//
//  UIView+MZCExtension.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/30.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

extension UIView{
    func vibrationAni(){
        self.userInteractionEnabled = false
        self.transform = CGAffineTransformMakeScale(0.0, 0.0)
        /**
         震动动画
         
         - parameter duration:     动画时间
         - parameter delay:        延迟时间
         - parameter dampingRatio: 震幅 0.0~1.0, 值越小震动越列害
         - parameter velocity:     加速度, 值越大震动越列害
         - parameter options:      动画附加属性
         - parameter animations:   执行动画的block
         - parameter completion:   执行完毕后回调的block
         */
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.transform = CGAffineTransformIdentity
            }, completion: { (_) -> Void in
                self.userInteractionEnabled = true
        })
    }
}
