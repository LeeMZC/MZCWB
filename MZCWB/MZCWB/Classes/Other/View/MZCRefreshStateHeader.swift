//
//  MZCRefreshStateHeader.swift
//  测试下拉刷新
//
//  Created by 马纵驰 on 16/8/6.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import MJRefresh

class MZCRefreshStateHeader: MJRefreshHeader {

    
    /** 文字距离圈圈、箭头的距离 */
    private lazy var labelLeftInset : CGFloat = 20
    /// 箭头动画时长
    private lazy var arrowViewAniTimer : Double = 0.25
    
    private lazy var stateLabel : UILabel! = {
        var label = UILabel()
        label.tintColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = NSTextAlignment.Center
        
        label.text = "fdsafdsa"
        self.addSubview(label)
    
        return label
    }()
    
    private lazy var arrowView : UIImageView! = {
        var imgView = UIImageView(image: UIImage.init(named: "tableview_pull_refresh"))
        self.addSubview(imgView)
        imgView.sizeToFit()
        return imgView
    }()
    
    private lazy var loadingView : UIImageView! = {
        var imgView = UIImageView(image: UIImage.init(named: "tableview_loading"))
        self.addSubview(imgView)
        imgView.sizeToFit()
        return imgView
    }()
    
    override func prepare() {
        super.prepare()
        mj_h = 50
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        var centerX = mj_w / 2
        
        if stateLabel.hidden == false {
            stateLabel.frame = self.bounds
            centerX -= stateLabel.mj_textWith() / 2 + labelLeftInset
        }
        
        let centerY = mj_h / 2
        let arrowViewCenter = CGPointMake(centerX, centerY)
        
        if arrowView.hidden == false {
            arrowView.center = arrowViewCenter
        }
        
        if loadingView.hidden == false {
            loadingView.center = arrowViewCenter
        }
    }
    
    private func arrowViewRotationAni(){
        UIView.animateWithDuration(arrowViewAniTimer) {
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - CGFloat(M_PI))
        }
        
    }
    
    private func arrowViewRecoveryAni(){
        UIView.animateWithDuration(arrowViewAniTimer) {
            self.arrowView.transform = CGAffineTransformIdentity
        }
    }
    
    private func loadingViewStartAni(){
        let anim : CABasicAnimation  = CABasicAnimation(keyPath: "transform.rotation")
        
        //设置属性值.
        anim.toValue = M_PI * 2
        //设置动画的执行次数
        anim.repeatCount = MAXFLOAT;
        //设置动画的执行时长
        anim.duration = 1;

        //添加动画
        loadingView.layer.addAnimation(anim, forKey: nil)
    }
    
    private func loadingViewStopAni(){
        loadingView.layer.removeAllAnimations()
    }
    
    override var state: MJRefreshState {
        
        didSet{
            
            if oldValue.hashValue == self.state.hashValue {return}
            
            super.state = self.state
            
            switch state {
            case MJRefreshState.Idle:
                stateLabel.text = "赶紧下拉吖"
                loadingView.hidden = true
                arrowView.hidden = false
                arrowViewRecoveryAni()
                loadingViewStopAni()
            case MJRefreshState.Pulling:
                stateLabel.text = "赶紧放开我吧"
                loadingView.hidden = true
                arrowView.hidden = false
                arrowViewRotationAni()
            case MJRefreshState.Refreshing:
                stateLabel.text = "加载数据中"
                loadingView.hidden = false
                arrowView.hidden = true
                arrowViewRecoveryAni()
                loadingViewStartAni()
            default:
                break
            }
        }
    }

}
