//
//  MZCHomePopUserInfoManager.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/10.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
protocol MZCHomeUserInfoDataSource : MZCBasePresentationControllerDataSource {
    func userInfoPresentationControllerRect() -> CGRect
}

class MZCHomeUserInfoPresentationController: MZCBasePresentationController {
    
    //MARK:- 开始弹出调用
    override func containerViewWillLayoutSubviews()
    {
        assert(dataSource != nil , "没有数据源")
        super.containerViewWillLayoutSubviews()
        containerView!.insertSubview(self.shadeView, atIndex: 0)
        
        let data = dataSource as! MZCHomeUserInfoDataSource
        presentedView()?.frame = data.userInfoPresentationControllerRect()
    }
    
    
    private lazy var shadeView : UIView = {
        
        let btn = UIButton(type: UIButtonType.Custom)
        btn.frame = UIScreen.mainScreen().bounds
        btn.backgroundColor = UIColor.clearColor()
        btn.addTarget(self, action: #selector(MZCHomeUserInfoPresentationController.screenDidOnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    @objc private func screenDidOnClick(){
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

//MARK:- AnimatedTransitioning
extension MZCHomeUserInfoPresentationController {
    
    //override 显示 和 消失 的动画时间
    override func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.5
    }
    
    /// 执行展现动画 override
    override func willPresentedController(transitionContext: UIViewControllerContextTransitioning)
    {
        // 1.获取需要弹出视图
        // 通过ToViewKey取出的就是toVC对应的view
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else
        {
            return
        }
        
        // 2.将需要弹出的视图添加到containerView上
        transitionContext.containerView()?.addSubview(toView)
        
        // 3.执行动画
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        // 设置锚点
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            toView.transform = CGAffineTransformIdentity
        }) { (_) -> Void in
            // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
            transitionContext.completeTransition(true)
        }
    }
    /// 执行消失动画 override
    override func willDismissedController(transitionContext: UIViewControllerContextTransitioning)
    {
        // 1.拿到需要消失的视图
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else
        {
            return
        }
        // 2.执行动画让视图消失
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            // 突然消失的原因: CGFloat不准确, 导致无法执行动画, 遇到这样的问题只需要将CGFloat的值设置为一个很小的值即可
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.00001)
            }, completion: { (_) -> Void in
                // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
                transitionContext.completeTransition(true)
        })
    }
}

extension MZCHomeUserInfoPresentationController {
    override func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        let pc = MZCHomeUserInfoPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pc.dataSource = dataSource
        return pc
    }
}

