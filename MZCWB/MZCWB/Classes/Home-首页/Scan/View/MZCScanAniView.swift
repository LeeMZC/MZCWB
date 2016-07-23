//
//  MZCScanAniView.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/23.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCScanAniView: UIView {

    
    @IBOutlet weak var waveImg: UIImageView!
    

    class func scanAniView() -> MZCScanAniView{
        
        return NSBundle.mainBundle().loadNibNamed("MZCScanAniView", owner: nil, options: nil).last as! MZCScanAniView
        
    }
    
    var imgHight = 200
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let x = viewSize.width / 2
        let y = viewSize.height / 2
        bounds.size = CGSizeMake(200 , CGFloat(imgHight))
        center = CGPointMake(x, y)
    }
    
    
    private lazy var viewSize : CGSize = {
        return UIScreen.mainScreen().bounds.size
    }()
    
    
    func startAni(){
        
        //移除动画
        waveImg.layer.removeAllAnimations()
        //重新布局
        setNeedsLayout()
        //初始化位置
        waveImg.transform = CGAffineTransformMakeTranslation(self.waveImg.frame.origin.x, CGFloat(-self.imgHight))
        
        // 2.执行扫描动画
        UIView.animateWithDuration(2.0) { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.waveImg.transform = CGAffineTransformMakeTranslation(self.waveImg.frame.origin.x, CGFloat(self.imgHight))
        }
    }

}
