//
//  MZCEmoticonGroup.swift
//  MZCCustomKeyboard
//
//  Created by 马纵驰 on 16/8/12.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

/** 搜索目录 */
private let MZCinDirectoryFileName = "Emoticons.bundle"
private let MZCRootFileName = "emoticons.plist"

private let groupCount = 21
class MZCEmoticonGroup: NSObject {
    //MARK:- 属性
    var id : String?
    
    var groupModes : [MZCEmoticonMode]?
    
    init(dict: [String: AnyObject])
    {
        super.init()
        self.setValuesForKeysWithDictionary(dict)
        groupModes = loadData()
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

//MARK:- public
extension MZCEmoticonGroup {
    class func loadData() -> [MZCEmoticonGroup] {
        let dict = NSBundle.mzc_pathForResource(fileName: MZCRootFileName, inDirectory: MZCinDirectoryFileName)
        let packages = dict["packages"] as! [[String : AnyObject]]
        
        var group : [MZCEmoticonGroup] = []
        group.append(MZCEmoticonGroup(dict: ["id" : "Lately"]))
        for dict in packages {
            group.append(MZCEmoticonGroup(dict: dict))
            
        }
        return group
    }
    
    func appendFavoriteEmoticon(mode aMode :MZCEmoticonMode) {
        
        groupModes?.removeLast()
        
        if !groupModes!.contains(aMode) {
            groupModes!.removeLast()
            groupModes!.append(aMode)
        }
        
        let sortNewGroup = groupModes!.sort({ (o1, o2) -> Bool in
            return o1.clickCount > o2.clickCount
        })
        
        groupModes = sortNewGroup
        groupModes?.append(MZCEmoticonMode(dict: nil, type: MZCEmoticonCellType.Delete))
        
    }
}

//MARK:- private
extension MZCEmoticonGroup {
    private func loadData() -> [MZCEmoticonMode]{
        var t_modes : [MZCEmoticonMode] = []
        
        if self.id != "Lately" {
            let path = NSBundle.mainBundle().pathForResource(id, ofType: nil, inDirectory: "Emoticons.bundle")!
            let filePath = (path as NSString).stringByAppendingPathComponent("info.plist")
            
            let dict = NSDictionary(contentsOfFile: filePath)
            
            let arr = dict!["emoticons"] as! [[String : AnyObject]]
            
            /** 变量所有数据组成模型 */
            for index in 0..<arr.count {
                var mode : MZCEmoticonMode
                /** 每页个数 - 1 每页倒数第二个后面添加一个删除按钮 */
                appendDeleteEmoticon(&t_modes, index: index)
                
                /** 添加数据 */
                let dict = arr[index] as [String : AnyObject]
                if self.id == "com.apple.emoji" {
                    mode = MZCEmoticonMode(dict: dict, type: MZCEmoticonCellType.Emoji)
                }else {
                    mode = MZCEmoticonMode(dict: dict, type: MZCEmoticonCellType.Img)
                }
                
                t_modes.append(mode)
                
            }
            
        }
        
        appendEmptyEmoticons(&t_modes)
        
        return t_modes
    
    }
    
    //MARK:-  每页个数 - 1 每页倒数第二个后面添加一个删除按钮
    private func appendDeleteEmoticon(inout modes : [MZCEmoticonMode] , index aIndex : Int ) {
        if aIndex % (groupCount - 1) == 0  && aIndex != 0{
            modes.append(MZCEmoticonMode(dict: nil, type: MZCEmoticonCellType.Delete))
        }
    }
    //MARK:- 不够一页个数补齐 (一页个数 - 总数 % 每页个数)
    private func appendEmptyEmoticons(inout modes : [MZCEmoticonMode]) {
        let placeholderCount = groupCount - modes.count % groupCount
        for index in 0..<placeholderCount
        {
            /** 如果是最后一个添加删除按钮 */
            if index == placeholderCount - 1  {
                modes.append(MZCEmoticonMode(dict: nil, type: MZCEmoticonCellType.Delete))
            }else {
                modes.append(MZCEmoticonMode(dict: nil, type: MZCEmoticonCellType.Empty))
            }
            
        }
    }
}


