//
//  MZCNSNotificationCenterMessage.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/27.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

class MZCNSNotificationCenterMessage: NSObject {
    static let shareInstance: MZCNSNotificationCenterMessage = {
        let instance = MZCNSNotificationCenterMessage()
        return instance
    }()
    
    func removeObserver(observer: NSObject){
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }

}
//MARK:- 注册通知
extension MZCNSNotificationCenterMessage{
    
    // 判断如果有新版本 切换新版本页面
    func uiWindowOfNewVersion(observer: AnyObject, selector aSelector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: aSelector, name: IsNewVersionCollectionViewControllerWillChange, object: nil)
    }
    
    // 切换新版本页面
    func welcomeViewControllerWillChange(observer: AnyObject, selector aSelector: Selector){
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: aSelector, name: MZCWelcomeViewControllerWillChange, object: nil)
    }
    
    // 切换主页面
    func mainUIWindowWillChange(observer: AnyObject, selector aSelector: Selector){
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: aSelector, name: MZCMainViewControllerWillChange, object: nil)
    }
    
    // 点击home页面标题
    func homeTitleButtonDidChange(observer: AnyObject, selector aSelector: Selector){
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: aSelector, name: MZCHomeTitleButtonDidChange, object: nil)
    }
    
    
    
}

//MARK:- 发送通知
extension MZCNSNotificationCenterMessage{
    // 判断如果有新版本 切换新版本页面
    func post_uiWindowOfNewVersion() {
        NSNotificationCenter.defaultCenter().postNotificationName(IsNewVersionCollectionViewControllerWillChange, object: nil)
    }
    
    // 切换新版本页面
    func post_welcomeViewControllerWillChange(){
        NSNotificationCenter.defaultCenter().postNotificationName(MZCWelcomeViewControllerWillChange, object: nil)
        
    }
    
    // 切换主页面
    func post_mainUIWindowWillChange(){
        NSNotificationCenter.defaultCenter().postNotificationName(MZCMainViewControllerWillChange, object: nil)
        
    }
    
    // 点击home页面标题
    func post_homeTitleButtonDidChange(){
        NSNotificationCenter.defaultCenter().postNotificationName(MZCHomeTitleButtonDidChange, object: nil)
    }
}
