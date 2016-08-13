//
//  MZCBasePresentationController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/10.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs


//MARK:- 数据源代理
protocol MZCBasePresentationControllerDataSource : NSObjectProtocol {
    
}

//MARK:- 转场控制器
class MZCBasePresentationController: UIPresentationController,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{
    var isPresent = false
    weak var dataSource : MZCBasePresentationControllerDataSource?
    
    
    /*
     1.如果不自定义转场modal出来的控制器会移除原有的控制器
     2.如果自定义转场modal出来的控制器不会移除原有的控制器
     3.如果不自定义转场modal出来的控制器的尺寸和屏幕一样
     4.如果自定义转场modal出来的控制器的尺寸我们可以自己在containerViewWillLayoutSubviews方法中控制
     5.containerView 非常重要, 容器视图, 所有modal出来的视图都是添加到containerView上的
     6.presentedView() 非常重要, 通过该方法能够拿到弹出的视图

    
    // 用于布局转场动画弹出的控件 即将弹出时调用一次
//    override func containerViewWillLayoutSubviews()
//    {
//        super.containerViewWillLayoutSubviews()
//    }
 
    
    required override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        
        (presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
    }
    
    required override init() {
        super.init()
    }
 */
    
}
//MARK:- UIViewControllerTransitioningDelegate
extension MZCBasePresentationController {
    //MARK:转场代理
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        let pc = MZCBasePresentationController(presentedViewController: presented, presentingViewController: presenting)
        
        pc.dataSource = dataSource
        return pc
    }
    
    //显示时调用
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return self
    }
    
    //消失时调用
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return self
    }
}

//MARK:- UIViewControllerAnimatedTransitioning
extension MZCBasePresentationController  {
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