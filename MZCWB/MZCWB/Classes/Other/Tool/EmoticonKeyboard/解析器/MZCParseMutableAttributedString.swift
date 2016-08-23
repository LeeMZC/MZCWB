//
//  MZCParseMutableAttributedString.swift
//  MZCCustomKeyboard
//
//  Created by 马纵驰 on 16/8/24.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

import UIKit
import YYKit
import QorumLogs

private let MZCinDirectoryFileName = "Emoticons.bundle"
private let MZCRootFileName = "emoticons.plist"

public enum MZCLinkType {
    case emoticonType
    case atType
    case topicType
    case httpType
}

class MZCParseMutableAttributedString: NSObject , YYTextParser{
    
    var font = MZCTextFont
    
    static let shareInstance: MZCParseMutableAttributedString = MZCParseMutableAttributedString()
    //MARK:- 图片数据
    lazy var dicEmoticon : [String : UIImage] = {
        
        var dicE = [String : UIImage]()
        
        let dict = NSBundle.mzc_pathForResource(fileName: MZCRootFileName, inDirectory: MZCinDirectoryFileName)
        
        let packages = dict["packages"] as! [[String : AnyObject]]
        
        for dict in packages {
            
            let id = dict["id"] as! String
            
            if id == "com.sina.default" || id == "com.sina.lxh" {
                let path = NSBundle.mainBundle().pathForResource(id, ofType: nil, inDirectory: "Emoticons.bundle")!
                let filePath = (path as NSString).stringByAppendingPathComponent("info.plist")
                
                let dict = NSDictionary(contentsOfFile: filePath)
                
                let arr = dict!["emoticons"] as! [[String : AnyObject]]
                
                for dic in arr {
                    
                    guard let key = dic["chs"] else {
                        continue
                    }
                    
                    guard let imgName = dic["png"] else {
                        continue
                    }
                    
                    let val = UIImage.init(named: imgName as! String)
                    
                    dicE[key as! String] = val
                }
            }
        }
        
        return dicE
    }()
    
    func parseString(mAttrString : NSMutableAttributedString) ->NSAttributedString {
        // 获取所有正则结果集
        let links = getRangesForLinks(mAttrString)
        // 根据正则结果集添加属性 返回值range用于控制光标
        self.addLinkAttributesToAttributedString(mAttrString, linkRanges: links)
        
        mAttrString.font = font
        
        return mAttrString
    }
}

//MARK:- private
extension MZCParseMutableAttributedString {
    
    
    
    //MARK:- 解析正则
    private func getRangesForLinks(mAttrString : NSMutableAttributedString) -> [[String : AnyObject]] {
        
        var links = [[String : AnyObject]]()
        
        links += httpParser(mAttrString)
        links += atParser(mAttrString)
        links += topicParser(mAttrString)
        links += emoticonParser(mAttrString)
        
        return links
    }
    
    //MARK:- 根据解析的正则添加属性
    private func addLinkAttributesToAttributedString(mAttrString : NSMutableAttributedString , linkRanges : [[String : AnyObject]]) -> NSRange? {
        
        // 保证添加完一个图片附件后 第二以后的range的正确
        var emoClipLength = 0;
        
        for dict in linkRanges {
            
            var range = dict["range"] as! NSRange
            let type = dict["type"] as! Int
            
            if type == MZCLinkType.emoticonType.hashValue {
                range.location -= emoClipLength;
                // [拜拜]
                let imgName = (mAttrString.string as NSString).substringWithRange(range)
                guard let img = dicEmoticon[imgName] else {
                    continue
                }
                // 图片附件
                let emoText = NSAttributedString.attachmentStringWithEmojiImage(img, fontSize: font.pointSize)
                // 图文混排
                mAttrString.replaceCharactersInRange(range, withAttributedString: emoText!)
                emoClipLength += range.length - 1;
                
            }else {
                //设置规则范围内颜色
                mAttrString.setColor(UIColor.blueColor(), range: range)
                let highlight = YYTextHighlight()
                // 设置点击数据
                highlight.userInfo = ["1" : "#数据"]
                // 设置高亮颜色
                highlight.setColor(UIColor.grayColor())
                mAttrString.setTextHighlight(highlight, range: range)
                
            }
            
        }
        
        guard let dict = linkRanges.last else {
            return nil
        }
        return ((dict["range"] as! NSRange))
    }
    
    
    private func httpParser(attributedText : NSMutableAttributedString) -> [[String : AnyObject]]{
        
        var links = [[String : AnyObject]]()
        
        let results = getResults("[a-zA-z]+://[^\\s]*", textStr: attributedText.string)
        
        for result in results {
            let range = result.range
            // 满足条件判断
            if range.location == NSNotFound && range.length <= 1 {continue}
            if ((attributedText.attribute(YYTextHighlightAttributeName, atIndex: UInt(range.location))) != nil) {continue}
            links.append(["range" : range , "type" : MZCLinkType.httpType.hashValue])
        }
        
        return links
    }
    
    private func atParser(attributedText : NSMutableAttributedString) -> [[String : AnyObject]]{
        
        var links = [[String : AnyObject]]()
        
        let results = getResults("@[-_a-zA-Z0-9\\u4E00-\\u9FA5]+", textStr: attributedText.string)
        
        for result in results {
            let range = result.range
            // 满足条件判断
            if range.location == NSNotFound && range.length <= 1 {continue}
            if ((attributedText.attribute(YYTextHighlightAttributeName, atIndex: UInt(range.location))) != nil) {continue}
            
            links.append(["range" : range , "type" : MZCLinkType.atType.hashValue])
        }
        return links
    }
    
    
    private func topicParser(attributedText : NSMutableAttributedString) -> [[String : AnyObject]]{
        
        var links = [[String : AnyObject]]()
        
        let results = getResults("#[^@#]+?#", textStr: attributedText.string )
        
        for result in results {
            let range = result.range
            // 满足条件判断
            if range.location == NSNotFound && range.length <= 1 {continue}
            if ((attributedText.attribute(YYTextHighlightAttributeName, atIndex: UInt(range.location))) != nil) {continue}
            links.append(["range" : range , "type" : MZCLinkType.topicType.hashValue])
        }
        
        return links
    }
    
    private func emoticonParser(attributedText : NSMutableAttributedString) -> [[String : AnyObject]]{
        
        var links = [[String : AnyObject]]()
        
        let results = getResults("\\[[^ \\[\\]]+?\\]" , textStr: attributedText.string)
        
        
        for result in results {
            let range = result.range
            // 满足条件判断
            if range.location == NSNotFound && range.length <= 1 {continue}
            if ((attributedText.attribute(YYTextHighlightAttributeName, atIndex: UInt(range.location))) != nil) {
                continue
            }
            if ((attributedText.attribute(YYTextAttachmentAttributeName, atIndex: UInt(range.location))) != nil) {
                continue
            }
            
            // 满足条件判断
            var containsBindingRange = false
            attributedText.enumerateAttribute(YYTextBindingAttributeName, inRange: range, options: NSAttributedStringEnumerationOptions.LongestEffectiveRangeNotRequired, usingBlock: { (value, _, stop) in
                if value != nil {
                    containsBindingRange = true
                    stop.memory = true
                }
            })
            if containsBindingRange {continue}
            
            links.append(["range" : range , "type" : MZCLinkType.emoticonType.hashValue])
        }
        
        
        return links
    }
    
    //MARK:- 获取正则结果集
    private func getResults(regExpStr : String , textStr : String) -> [NSTextCheckingResult] {
        
        let regex = try! NSRegularExpression(pattern: regExpStr, options: NSRegularExpressionOptions.CaseInsensitive)
        // 3.匹配结果
        return regex.matchesInString(textStr, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: textStr.characters.count))
    }
    
    
}

//MARK:- delegate
extension MZCParseMutableAttributedString  {
    func parseText(text: NSMutableAttributedString?, selectedRange: NSRangePointer) -> Bool {
        
        // 获取所有正则结果集
        let links = self.getRangesForLinks(text!)
        
        // 根据正则结果集添加属性 返回值range用于控制光标
        guard let range = self.addLinkAttributesToAttributedString(text!, linkRanges: links) else {
            return true
        }
        
        // 设置光标位置
        if selectedRange.hashValue == 0 {return true}
        selectedRange.memory.location = range.location + 1
        
        // 从新设置文本大小 否则 图片后如果是emoji表情.emoji表情缩小
        text?.font = font
        return true
    }
    
}
