//
//  String+MZCExtension.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/26.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

extension String {
    /// 快速生成缓存路径
    func cachesDir() -> String
    {
        // 1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)
        
        return filePath
    }
    /// 快速生成文档路径
    func docDir() -> String
    {
        // 1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)
        
        return filePath
    }
    /// 快速生成临时路径
    func tmpDir() -> String
    {
        // 1.获取缓存目录的路径
        let path = NSTemporaryDirectory()
        
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)
        
        return filePath
    }
    //MARK:- 计算文字矩形
    func mzc_stringSize(width awidth : CGFloat) -> CGSize {
        
        if self.characters.count > 0 {
            
            let textMaxSize = CGSizeMake(CGFloat(awidth), CGFloat(MAXFLOAT))
            let size = self.boundingRectWithSize(textMaxSize, options: [NSStringDrawingOptions.UsesLineFragmentOrigin , NSStringDrawingOptions.UsesFontLeading] , attributes: [NSFontAttributeName : MZCTopicfont], context: nil).size
            return size
        }
        
        return CGSizeZero
    }
    
    func mzc_stringOfHexadecimal() ->String {
        
        if self.characters.count < 1 { return "" }
        
        // 1.创建一个扫描器
        let scanner = NSScanner(string: self)
        // 2.从字符串中扫描出对应的16进制数
        var result: UInt32 = 0
        scanner.scanHexInt(&result)
        // 3.根据扫描出的16进制创建一个字符串
        return "\(Character(UnicodeScalar(result)))"
    }
}
