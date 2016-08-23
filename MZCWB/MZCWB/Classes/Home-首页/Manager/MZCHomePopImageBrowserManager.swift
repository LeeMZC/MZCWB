//
//  MZCHomePopImageBrowserManager.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/10.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
import YYKit

protocol MZCHomePopImageBrowserDataSource : MZCBasePresentationControllerDataSource {
    func imageBrowserData() -> UIImage?
}

class MZCHomePopImageBrowserPresentationController: MZCBasePresentationController {
    
    //MARK:- 开始弹出调用
    //5.containerView 非常重要, 容器视图, 所有modal出来的视图都是添加到containerView上的
    //6.presentedView() 非常重要, 通过该方法能够拿到弹出的视图
    //let data = ["selectedIndexPath" : selectedIndexPath , "pic_urls_middle" : pic_urls_middle]
    //MARK:- 转场展示图片数据源
    private lazy var imgView : UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()

    private var img : UIImage {
        let dataSource = self.dataSource as! MZCHomePopImageBrowserDataSource
        guard let image = dataSource.imageBrowserData() else {
            fatalError("img不存在")
        }
        return image
    }
    
    override func containerViewWillLayoutSubviews()
    {

        if img.size.height > MZCScreenSize.height {
            let size = MZCScreenSize
            let frame = CGRectMake(0, 0, size.width, size.height)
            self.imgView.frame = frame
            containerView?.frame = frame
//            presentedView()?.frame = frame
        }else{
            let bounds = UIScreen.mainScreen().bounds
            containerView?.bounds = bounds
//            presentedView()?.bounds = bounds
        }
    }
}

//MARK:- AnimatedTransitioning
extension MZCHomePopImageBrowserPresentationController {
    
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
        
        guard let containerView = transitionContext.containerView() else {
            return
        }
        
        imgView.image = img
        
        containerView.addSubview(imgView)
        
        imgView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        imgView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        imgView.center = CGPointMake(MZCScreenSize.width / 2, MZCScreenSize.height / 2)
        imgView.bounds.size = (self.imgView.image?.mzc_fixedWidthScalingSize())!
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            self.imgView.transform = CGAffineTransformIdentity
        }) { (_) -> Void in
            // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
            self.imgView.removeFromSuperview()
            transitionContext.completeTransition(true)
            // 2.将需要弹出的视图添加到containerView上
            containerView.addSubview(toView)
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
        
//         2.执行动画让视图消失
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            // 突然消失的原因: CGFloat不准确, 导致无法执行动画, 遇到这样的问题只需要将CGFloat的值设置为一个很小的值即可
            fromView.transform = CGAffineTransformMakeScale(0.000001, 0.00001)
            }, completion: { (_) -> Void in
                // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
                transitionContext.completeTransition(true)
        })
    }
}

extension MZCHomePopImageBrowserPresentationController {
    override func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        let pc = MZCHomePopImageBrowserPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pc.dataSource = dataSource
        return pc
    }
}