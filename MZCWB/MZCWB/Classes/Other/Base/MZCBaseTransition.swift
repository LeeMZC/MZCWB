//
//  MZCBaseTransition.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/22.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

class MZCBaseTransition: UIViewController, UIViewControllerTransitioningDelegate ,  UIViewControllerAnimatedTransitioning{

    private var isPresent = false
    private var presentFrame : CGRect?
    
    convenience init(presentFrame : CGRect) {
        self.init()
        self.presentFrame = presentFrame
    }
    
    //MARK:转场代理
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        
        guard let tempFrame = presentFrame else{
            return MZCPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        
        return MZCPresentationController(frame:tempFrame, presentedViewController: presented, presentingViewController: presenting)
    }
    
    //    //显示时调用
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return self
    }
    
    //消失时调用
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return self
    }
    
    //override 显示 和 消失 的动画时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        
        isPresent ? willDismissedController(transitionContext) : willPresentedController(transitionContext)
        isPresent = !isPresent
    }
    
    /// 执行展现动画 override
    func willPresentedController(transitionContext: UIViewControllerContextTransitioning)
    {
        /**
        1.获取需要弹出视图
        通过ToViewKey取出的就是toVC对应的view
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else
        {
            return
        }
        
        2.将需要弹出的视图添加到containerView上
        transitionContext.containerView()?.addSubview(toView)
        
        3.执行动画
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        设置锚点
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            toView.transform = CGAffineTransformIdentity
        }) { (_) -> Void in
            注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
            transitionContext.completeTransition(true)
        }
         */
    }
    /// 执行消失动画 override
    func willDismissedController(transitionContext: UIViewControllerContextTransitioning)
    {
        /**
        1.拿到需要消失的视图
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else
        {
            return
        }
        2.执行动画让视图消失
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            // 突然消失的原因: CGFloat不准确, 导致无法执行动画, 遇到这样的问题只需要将CGFloat的值设置为一个很小的值即可
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.00001)
            }, completion: { (_) -> Void in
                // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
                transitionContext.completeTransition(true)
        })
        */
    }
    
}
