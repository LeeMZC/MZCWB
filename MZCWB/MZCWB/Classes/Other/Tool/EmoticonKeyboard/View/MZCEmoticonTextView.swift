//
//  MZCEmoticonTextView.swift
//  MZCCustomKeyboard
//
//  Created by 马纵驰 on 16/8/14.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs

class MZCEmoticonTextView: UITextView {
    
    //MARK:- lazy
    lazy var placeholderLabel : UILabel = {
        let label = UILabel()
        label.text = "分享新鲜事..."
        label.tintColor = UIColor.grayColor()
        label.font = self.font
        label.sizeToFit()
        return label
    }()
    
    
    //MARK:- 生命周期
    override func awakeFromNib() {
        setupUI()
    }
    /** 布局子控件 */
    override func layoutSubviews() {
        placeholderLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(4)
            make.top.equalTo(self).offset(8)
        }
    }
    
    func insertEmoticon(emoticon : MZCEmoticonMode) {
        
        switch emoticon.emoticonType! {
        case MZCEmoticonType.Img:
            insetImg(emoticon)
        case MZCEmoticonType.Emoji:
            insertEmoji(emoticon)
        case MZCEmoticonType.Delete:
            deleteBackward()
        default:
            break
        }
    }
    
    func textViewStr() -> String {
    
        let range = NSRange(location: 0, length: attributedText.length)
        var str = String()
        attributedText.enumerateAttributesInRange(range, options: NSAttributedStringEnumerationOptions(rawValue: 0)) {[weak self] (dict, range, _) in
            let weakSelf = self
            // 判断附件文本还是字符串
            if let attachment = dict["NSAttachment"] as? MZCKeyboardAttachment {
                //取出附件对应的文本拼接字符串 (图片)
                str += attachment.emoticonChs!
            } else {
                //拼接普通字符串
                str += (weakSelf!.text as NSString).substringWithRange(range)
            }
        }
        
        return str
    }

}

//MARK:- private
extension MZCEmoticonTextView {
    // 插入表情图片
    private func insetImg(emoticon : MZCEmoticonMode) {
        // 创建副本
        let lineHeight = font!.lineHeight
        let ali = MZCKeyboardAttachment()
        // 副本保存对应的字符串
        ali.emoticonChs = emoticon.chs
        ali.image = UIImage(named: emoticon.sourceName)
        ali.bounds = CGRectMake(0, -4, lineHeight, lineHeight)
        let imgAttrStr = NSAttributedString(attachment: ali)
        
        //根据副本创建属性字符串
        let attrStr = NSMutableAttributedString(attributedString: attributedText)
        attrStr.replaceCharactersInRange(selectedRange, withAttributedString: imgAttrStr)
        let range = selectedRange
        attributedText = attrStr
        selectedRange = NSRange(location: range.location + 1, length: 0)
        font = UIFont.systemFontOfSize(17)
        
    }
    // 插入emoji表情
    private func insertEmoji(emoticon : MZCEmoticonMode){
        // 1.2.用emoji表情替换光标所在的位置
        replaceRange(selectedTextRange!, withText: emoticon.sourceName)
    }
    
    /** setupUI */
    private func setupUI(){
        addSubview(placeholderLabel)
    }
}

class MZCKeyboardAttachment: NSTextAttachment {
    var emoticonChs : String?
}
