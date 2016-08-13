//
//  NSDate+MZCExtension.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/30.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

extension NSDate
{
    /// 根据一个字符串创建一个NSDate
    class func createDate(timeStr: String, formatterStr: String) -> NSDate
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = formatterStr
        // 如果不指定以下代码, 在真机中可能无法转换
        formatter.locale = NSLocale(localeIdentifier: "en")
        return formatter.dateFromString(timeStr)!
    }

}
