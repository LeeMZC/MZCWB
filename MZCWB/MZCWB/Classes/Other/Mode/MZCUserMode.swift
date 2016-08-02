//
//  MZCUserMode.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/25.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

class MZCUserMode: NSObject ,NSCoding{
    
    /// 用户UID
    var id = 0
    /// 用户名称
    var screen_name : String?
    /// 用户头像地址 用户头像地址（大图），180×180像素
    var avatar_large : String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    /// 用户认证类型
    var verified_type: Int = -1
    /// 字符串型的用户UID
    var idstr: String?
    /// 会员等级 ,取值范围 1~6
    var mbrank: Int = -1
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    // 当KVC发现没有对应的key时就会调用
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    //归档
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeInteger(id, forKey: "id")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        
    }
    //解归档
    required init?(coder aDecoder: NSCoder)
    {
        
        self.id = aDecoder.decodeIntegerForKey("id") as Int
        self.screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        self.avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        
    }
}
