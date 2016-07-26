//
//  AppDelegate.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/19.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK:- 属性
    var window: UIWindow?
    
    var baseTabBarController : MZCBaseTabBarViewController?
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        addNotif()
        
        QorumLogs.enabled = true;
        // 1.创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        // 2.设置根控制器
        uiwindowRootVC()
        // 3.显示window
        window?.makeKeyAndVisible()
        
        return true
    }
    
    //MARK:- private函数
    private func addNotif(){
       
        // 判断如果有新版本 切换新版本页面
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.uiWindowOfNewVersion), name: IsNewVersionCollectionViewControllerWillChange, object: nil)
        
        // 切换新版本页面
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.welcomeViewControllerWillChange), name: MZCWelcomeViewControllerWillChange, object: nil)
        
        // 切换主页面
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.mainUIWindowWillChange), name: MZCMainViewControllerWillChange, object: nil)
    }
    
    //MARK:根据逻辑切换UIWindow
    @objc private func uiwindowRootVC(){
        
        if isLogin() {
            uiWindowOfNewVersion()
        }else {
            window?.rootViewController = MZCLoginTabBarViewController()
        }
    }
    
    private func isLogin() -> Bool{
        if MZCAccountTokenMode.accountToKen() != nil {
            return true
        }
        
        return false
    }
    
    //MARK: 判断是否新颁布
    private lazy var isNewVersion : Bool = {
        
        
        // 1.加载info.plist
        // 2.获取当前软件的版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        // 3.获取以前的软件版本号?
        let defaults = NSUserDefaults.standardUserDefaults()
        let sanboxVersion = (defaults.objectForKey("xxoo") as? String) ?? "0.0"
        // 4.用当前的版本号和以前的版本号进行比较
        // 1.0  0.0
        if currentVersion.compare(sanboxVersion) == NSComparisonResult.OrderedDescending
        {
            // 如果当前的大于以前的, 有新版本
            QL1("有新版本")
            // 如果有新版本, 就利用新版本的版本号更新本地的版本号
            
            defaults.setObject(currentVersion, forKey: "xxoo")
            defaults.synchronize() // iOS7以前需要写, iOS7以后不用写
            return true
        }
        QL1("没有新版本")
        return false
        
    }()
    
    @objc private func uiWindowOfNewVersion(){
        if isNewVersion {
            window?.rootViewController = MZCNewVersionCollectionViewController()
        }else {
            window?.rootViewController = MZCWelcomeViewController()
        }
    }
    
    @objc private func mainUIWindowWillChange(){
        window?.rootViewController = MZCTabBarController()
    }
    
    @objc private func welcomeViewControllerWillChange(){
        window?.rootViewController = MZCWelcomeViewController()
    }

}

