//
//  MZCSetupUIMe.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/20.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCSetupUIMe: NSObject {

}

extension MZCSetupUIMe : MZCSetupUILoginBase{
    func setupUI(loginViewController: MZCLoginViewController) {
        loginViewController.setupUI("visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
    }
}