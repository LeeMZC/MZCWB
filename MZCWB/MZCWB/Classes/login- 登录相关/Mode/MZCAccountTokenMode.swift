//
//  MZCAccountTokenMode.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/25.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCAccountTokenMode: NSObject , NSCoding{
    /// 令牌
    var access_token: String?
    
    /// 从授权那一刻开始, 多少秒之后过期时间
    var expires_in: Int = 0
        {
        didSet{
            // 生成正在过期时间
            expires_Date = NSDate(timeIntervalSinceNow: NSTimeInterval(expires_in))
        }
    }
    /// 真正过期时间
    var expires_Date: NSDate?
    
    // 自己的模型
    var user : MZCUserMode?
    
    // MARK: - 生命周期方法
    init(dict: [String: AnyObject])
    {
        super.init()
        self.setValuesForKeysWithDictionary(dict)
    }
    
    // 当KVC发现没有对应的key时就会调用
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        // 将模型转换为字典
        let property = ["access_token", "expires_in", "uid", "expires_Date"]
        let dict = dictionaryWithValuesForKeys(property)
        // 将字典转换为字符串
        return "\(dict)"
    }
    
    //MARK:- 自定义函数
    func saveAccountToKen() -> Bool{
        
        return NSKeyedArchiver.archiveRootObject(self, toFile: MZCTokenModefilePath)
    }
    
    class func accountToKen() -> MZCAccountTokenMode?{
        QL1(MZCTokenModefilePath)
        guard let accountToKen = NSKeyedUnarchiver.unarchiveObjectWithFile(MZCTokenModefilePath) as? MZCAccountTokenMode else
        {
            return  nil
        }
        
        // 2015 2016
        guard let date = accountToKen.expires_Date where date.compare(NSDate()) != NSComparisonResult.OrderedAscending  else
        {
            return nil
        }
        accountTokenMode = accountToKen
        return accountToKen
    }
    
    //归档
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeInteger(expires_in, forKey: "expires_in")
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(user, forKey: "user")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
    }
    //解归档
    required init?(coder aDecoder: NSCoder)
    {
        self.expires_in = aDecoder.decodeIntegerForKey("expires_in") as Int
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        self.user = aDecoder.decodeObjectForKey("user") as? MZCUserMode
    }
}
