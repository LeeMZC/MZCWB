//
//  MZCSetupUIMessage.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/20.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCSetupUIMessage: NSObject {

}

extension MZCSetupUIMessage : MZCSetupUILoginBase{
    func setupUI(loginViewController: MZCLoginViewController) {
        loginViewController.setupUI("visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
    }
}