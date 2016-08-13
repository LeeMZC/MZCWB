//
//  NSBundle+MZCExtension.swift
//  MZCCustomKeyboard
//
//  Created by 马纵驰 on 16/8/12.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import Foundation
extension NSBundle {
    
    class func mzc_pathForResource(fileName aFileName : String , inDirectory aInDirectory : String) -> [String : AnyObject]{
        let path = NSBundle.mainBundle().pathForResource(aFileName, ofType: nil, inDirectory: aInDirectory)
        let dic = NSDictionary(contentsOfFile: path!) as! [String : AnyObject]
        return dic
    }
}