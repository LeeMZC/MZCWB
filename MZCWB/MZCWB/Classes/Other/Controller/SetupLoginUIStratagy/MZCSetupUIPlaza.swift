//
//  MZCSetupUIPlaza.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/20.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCSetupUIPlaza: NSObject {

}

extension MZCSetupUIPlaza : MZCSetupUILoginBase{
    func setupUI(loginViewController: MZCLoginViewController) {
        loginViewController.showTitle.text = "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过"
        loginViewController.iconImageView.image = UIImage.init(named: "visitordiscover_image_message")
    }
}