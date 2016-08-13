//
//  MZCEmoticonMode.swift
//  MZCCustomKeyboard
//
//  Created by 马纵驰 on 16/8/12.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

public enum MZCEmoticonCellType {
    
    case Empty
    case Delete
    case Emoji
    case Img
    
}

class MZCEmoticonMode: NSObject {
    
    var chs : String?
    var png : String?
    var type : String?
    var code : String?
    var clickCount : Int = 0
    var cellType : MZCEmoticonCellType?
    
    lazy var sourceName : String = {
        
        guard let type = self.cellType else {
            fatalError("cell类型不确定")
        }
        
        switch type {
        case MZCEmoticonCellType.Empty:
            return ""
        case MZCEmoticonCellType.Delete:
            return "compose_emotion_delete"
        case MZCEmoticonCellType.Emoji:
            guard let code = self.code else {
                fatalError("code无值")
            }
            return code.mzc_stringOfHexadecimal()
        case MZCEmoticonCellType.Img:
            guard let pngName = self.png else {
                fatalError("png无值")
            }
            return pngName
        }
        
    }()
    
    init(dict: [String: AnyObject]? , type : MZCEmoticonCellType)
    {
        super.init()
        if let t_dict = dict {
            self.setValuesForKeysWithDictionary(t_dict)
        }
        cellType = type

    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

    
}
