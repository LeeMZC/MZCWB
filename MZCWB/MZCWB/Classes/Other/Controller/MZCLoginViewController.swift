//
//  MZCLoginViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/20.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
enum MZCViewControllerType: Int {
    case MZCHome
    case MZCMessage
    case MZCPlaza
    case MZCMe
}

class MZCLoginViewController: UIViewController {
    
    // 转盘
    @IBOutlet weak var rotationImageView: UIImageView!
    // 图标
    @IBOutlet weak var iconImageView: UIImageView!
    // 文本标签
    @IBOutlet weak var showTitle: UILabel!

    var delegate: MZCSetupUILoginBase?
    
    //MARK:- 初始化类型
    convenience init(type : MZCViewControllerType){
        self.init()
        
        switch type {
        case MZCViewControllerType.MZCHome:
            self.delegate = MZCSetupUIHome()
        case MZCViewControllerType.MZCMessage:
            self.delegate = MZCSetupUIMessage()
        case MZCViewControllerType.MZCPlaza:
            self.delegate = MZCSetupUIPlaza()
        case MZCViewControllerType.MZCMe:
            self.delegate = MZCSetupUIMe()
        }
        
    }
    
    //MARK:- 旋转动画
    func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 20.0
        anim.removedOnCompletion = false
        self.rotationImageView.layer.addAnimation(anim, forKey: nil)
    }
    
    override func viewDidLoad() {
        self.delegate?.setupUI(self)
    }
    
    //MARK:- 点击事件
    @IBAction func registerDidOnClick(sender: UIButton) {
        QL1("")
    }
    
    @IBAction func loginDidOnClick(sender: UIButton) {
        QL1("")
    }
    
}
