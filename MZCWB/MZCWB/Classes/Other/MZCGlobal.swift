//
//  MZCGlobal.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/23.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
//MARK:- 通知
// Home页标题按钮点击形状改变
let MZCHomeTitleButtonDidChange = "MZCHomeTitleButtonDidChangeFrameNotification"
// 切换欢迎界面
let MZCWelcomeViewControllerWillChange = "MZCWelcomeViewControllerWillChange"
// 切换主页面
let MZCMainViewControllerWillChange = "MZCMainWindowWillChange"
// 如果有新版本切换新版本页面
let IsNewVersionCollectionViewControllerWillChange = "NewVersionCollectionViewControllerWillChange"

//MARK:- baseURL
let baseURL = "https://api.weibo.com/"

//MARK:-请求授权参数
let MZCAppKey = "3941371959"
let MZCAppSecret = "54aaa1cbb48b667391c4d853adfd8071"
let MZCRedirect = "http://www.baidu.com"

//MARK:- 存储令牌序列化路径
let tokenModefilePath: String = "accountTokenMode.plist".cachesDir()