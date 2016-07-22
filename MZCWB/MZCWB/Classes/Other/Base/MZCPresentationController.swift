//
//  MZCPresentationController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/21.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

class MZCPresentationController: UIPresentationController {
    //弹出视图大小
     private var presentFrame: CGRect?
    
    /*
     1.如果不自定义转场modal出来的控制器会移除原有的控制器
     2.如果自定义转场modal出来的控制器不会移除原有的控制器
     3.如果不自定义转场modal出来的控制器的尺寸和屏幕一样
     4.如果自定义转场modal出来的控制器的尺寸我们可以自己在containerViewWillLayoutSubviews方法中控制
     5.containerView 非常重要, 容器视图, 所有modal出来的视图都是添加到containerView上的
     6.presentedView() 非常重要, 通过该方法能够拿到弹出的视图
     */
    convenience init(frame: CGRect,presentedViewController: UIViewController, presentingViewController: UIViewController) {
        self.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        self.presentFrame = frame
    }
    
    // 用于布局转场动画弹出的控件
    override func containerViewWillLayoutSubviews()
    {
        
        guard let frame = presentFrame else{
            return
        }
        
        containerView!.insertSubview(self.shadeView, atIndex: 0)
        
        // 设置弹出视图的尺寸
        presentedView()?.frame = frame
    }
    
    private lazy var shadeView : UIView = {
        
        let btn = UIButton(type: UIButtonType.Custom)
        btn.frame = UIScreen.mainScreen().bounds
        btn.backgroundColor = UIColor.clearColor()
        btn.addTarget(self, action: #selector(MZCPresentationController.screenDidOnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    @objc private func screenDidOnClick(){
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
