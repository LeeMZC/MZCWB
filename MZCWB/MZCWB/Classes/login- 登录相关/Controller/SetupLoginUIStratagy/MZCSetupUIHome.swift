//
//  MZCSetupUIHome.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/20.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCSetupUIHome: NSObject , MZCSetupUILoginBase{
    func setupUI(loginViewController: MZCLoginViewController) {
        loginViewController.setupUI("visitordiscover_feed_image_house", title: "关注一些人，回这里看看有什么惊喜" )
    }
}


