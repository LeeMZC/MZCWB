//
//  MZCHomeMode.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/29.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
import SwiftyJSON
class MZCHomeMode: NSObject {
    /// 微博创建时间
    var created_at: String?
    
    /// 字符串型的微博ID
    var idstr: String?
    
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String?
    
    /// 配图数组
    var pic_urls: [[String: String]]?
    
    /// 微博作者的用户信息
    var user: MZCUserMode?
    
    /// 转发微博
    var retweeted_status: MZCHomeMode?
    
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    /// KVC的setValuesForKeysWithDictionary方法内部会调用setValue方法
    override func setValue(value: AnyObject?, forKey key: String) {
        
        
        /// 拦截user赋值操作
        if key == "user"
        {
            user = MZCUserMode(dict: value as! [String : AnyObject])
            return
        }
        /// 拦截转发
        if key == "retweeted_status"
        {
            retweeted_status = MZCHomeMode(dict: value as! [String : AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["created_at", "idstr", "text", "source"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }
}
