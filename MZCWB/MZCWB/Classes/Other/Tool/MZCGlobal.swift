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
let MZCPictureWillShow = "MZCPictureWillShow"

//MARK:- baseURL
let baseURL = "https://api.weibo.com/"

//MARK:-请求授权参数
let MZCAppKey = "3941371959"
let MZCAppSecret = "54aaa1cbb48b667391c4d853adfd8071"
let MZCRedirect = "http://www.baidu.com"

//MARK:- 存储令牌序列化路径
let MZCTokenModefilePath: String = "accountTokenMode.plist".cachesDir()

//MARK:- 用户信息(自己)
var accountTokenMode : MZCAccountTokenMode?
let MZCDefaultFont : UIFont = UIFont.systemFontOfSize(17)
let MZCTextFont : UIFont = UIFont.systemFontOfSize(15)
//MARK:- 间距
let MZCMargin : CGFloat = 10.0
let MZCMinMargin : CGFloat = 5.0

//MARK:- 欢迎动画时长
let MZCWelcomeAniTimer = 0.3
//MARK:- 屏幕size
let MZCScreenSize = UIScreen.mainScreen().bounds.size
//MARK:- 主题内容文字大小
let MZCTopicfont : UIFont = UIFont.systemFontOfSize(15)
//MARK:- 头像宽高
let MZCHeadIconWH : CGFloat = 60
//MARK:- 主题TabBarView高度
let MZCTopicTabBarH : CGFloat = 50
//MARK:- 主题贴图格子宽高
let MZCTopicBoxWH : CGFloat = 90
//MARK:- 原创内容最大宽度
let MZCTopicContentMAXWidth = MZCScreenSize.width - MZCMargin * 3 - MZCHeadIconWH


//MARK:- 随机色
var MZCRandomColor : UIColor {
    return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1)
}

//MARK:- 桌面路径
let MZCPath = "/Users/mzc/Desktop/json.text"
