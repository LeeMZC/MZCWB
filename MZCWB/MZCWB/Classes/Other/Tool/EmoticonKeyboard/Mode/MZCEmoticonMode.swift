//
//  MZCEmoticonMode.swift
//  MZCCustomKeyboard
//
//  Created by 马纵驰 on 16/8/12.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

public enum MZCEmoticonType {
    
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
    var emoticonType : MZCEmoticonType?
    
    lazy var sourceName : String = {
        
        guard let type = self.emoticonType else {
            fatalError("cell类型不确定")
        }
        
        switch type {
        case MZCEmoticonType.Empty:
            return ""
        case MZCEmoticonType.Delete:
            return "compose_emotion_delete"
        case MZCEmoticonType.Emoji:
            guard let code = self.code else {
                fatalError("code无值")
            }
            return code.mzc_stringOfHexadecimal()
        case MZCEmoticonType.Img:
            guard let pngName = self.png else {
                fatalError("png无值")
            }
            return pngName
        }
        
    }()
    
    init(dict: [String: AnyObject]? , type : MZCEmoticonType)
    {
        super.init()
        if let t_dict = dict {
            self.setValuesForKeysWithDictionary(t_dict)
        }
        emoticonType = type

    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

    
}
