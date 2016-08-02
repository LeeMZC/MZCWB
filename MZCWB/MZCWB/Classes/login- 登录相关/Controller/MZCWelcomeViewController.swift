//
//  MZCWelcomeViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/27.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import YYWebImage
import QorumLogs

class MZCWelcomeViewController: UIViewController {

    @IBOutlet weak var userIcon_imgView: UIImageView!
    
    @IBOutlet weak var welcome_label: UILabel!
    
    @IBOutlet weak var iconButtom_layout: NSLayoutConstraint!
    // 圆角数值
    let userIconRadius = 10 as CGFloat
    
    override func viewDidLoad() {
        QL1("")
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    func setupUI(){
        guard let accountTokenMode = MZCAccountTokenMode.accountToKen() else {
            return
        }
        
        let iconUrlString = accountTokenMode.user?.avatar_large
        let iconUrl = NSURL(string: iconUrlString!)
        userIcon_imgView.setImageWithURL(iconUrl!, placeholderImage: UIImage.init(named: "avatar_default_big"))
        //设置圆角
        userIcon_imgView.layer.cornerRadius = userIconRadius
        userIcon_imgView.clipsToBounds = true
        
        welcome_label.alpha = 0
        let iconOffset = view.bounds.size.height - iconButtom_layout.constant
        
        UIView.animateWithDuration(MZCWelcomeAniTimer, animations: {
            //开始动画
            self.iconButtom_layout.constant = iconOffset
            self.view.layoutIfNeeded()
        }) { (true) in
            UIView.animateWithDuration(MZCWelcomeAniTimer, animations: {
                self.welcome_label.alpha = 1
                }, completion: { (_) in
                    //通知更换UIWindow
                    MZCNSNotificationCenterMessage.shareInstance.post_mainUIWindowWillChange()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
