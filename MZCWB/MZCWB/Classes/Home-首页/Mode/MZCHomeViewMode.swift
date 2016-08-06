//
//  MZCHomeViewMode.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/30.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
import YYWebImage
class MZCHomeViewMode: NSObject {
    // mode源对象
    var modeSource : MZCHomeMode?
    
    /// 用户头像
    lazy var profile_image_url_ViewMode : NSURL = {
        
        let url = NSURL(string: (self.modeSource?.user?.profile_image_url) ?? "")
        
        return url!
    }()
    
    /// 用户认证类型
    lazy var verified_type_ViewMode : UIImage? = {
        
        var img : UIImage?
        
        switch self.modeSource!.user!.verified_type
        {
        case 0:
            img = UIImage.init(named: "avatar_vip")
        case 2, 3, 5:
            img = UIImage.init(named: "avatar_enterprise_vip")
        case 220:
            img = UIImage.init(named: "avatar_grassroot")
        default:
            img = nil
        }
        
        return img
    }()
    
    /// 会员等级 ,取值范围 1~6

    lazy var mbrank_ViewMode : UIImage? = {
        
        if self.modeSource!.user!.mbrank >= 1 && self.modeSource!.user!.mbrank <= 6
        {
            return UIImage.init(named : "common_icon_membership_level\(self.modeSource!.user!.mbrank)")
        }
        
        return nil
    }()
    
    /// 微博创建时间
    
    private lazy var head = MZCTimeHead()
    private lazy var today = MZCToday()
    private lazy var yesterday = MZCYesterday()
    private lazy var year = MZCYear()
    private lazy var yearAgo = MZCYearAgo()
    private lazy var end = MZCTimeEnd()
    
    
    lazy var created_at_ViewMode : String = {
        
        let createDate = NSDate.createDate(self.modeSource!.created_at!, formatterStr: "EE MM dd HH:mm:ss Z yyyy")
        
        self.head.nextSuccessor = self.today
        self.today.nextSuccessor = self.yesterday
        self.yesterday.nextSuccessor = self.year
        self.year.nextSuccessor = self.yearAgo
        self.yearAgo.nextSuccessor = self.end
        
        return self.head.handleRequest(createDate)
    }()
    
    /// 微博来源
    lazy var source_ViewMode : String = {
        guard let sourceString : NSString = (self.modeSource!.source! as NSString) where sourceString.length > 0 else{
            return ""
        }
        // 6.1获取从什么地方开始截取
        let startIndex = sourceString.rangeOfString(">").location + 1
        // 6.2获取截取多长的长度
        let length = sourceString.rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
        
        // 6.3截取字符串
        let rest = sourceString.substringWithRange(NSMakeRange(startIndex, length))
        return "来自: " + rest
    }()
        
    //MARK:- 配图缓存所有url
    lazy var pic_urls_ViewMode : [NSURL]? = {
        
        let forwardUrls = self.modeSource?.retweeted_status?.pic_urls
        let originalUrls = self.modeSource?.pic_urls
        
        let pic_urls = self.isForward ? forwardUrls : originalUrls
        
        guard let t_pic_urls = pic_urls where t_pic_urls.count > 0 else {
            return nil
        }
        
        var urls = [NSURL]()
        // 2.遍历配图数组下载图片
        for dict in t_pic_urls
        {
            // 2.1取出图片的URL字符串
            guard let urlStr = dict["thumbnail_pic"] else
            {
                continue
            }
            // 2.2根据字符串创建URL
            let url = NSURL(string: urlStr)!
            urls.append(url)
        }
        
        return urls
        
    }()
    
    //MARK:- 转发文本
    lazy var source_forward_ViewMode : String? = {
        
        guard let forwardMode = self.modeSource?.retweeted_status else {
            return nil
        }
        
        guard let text = forwardMode.text where text.characters.count > 0 else {
            return nil
        }
        
        let name = self.modeSource!.retweeted_status!.user?.screen_name ?? ""
        return "@" + name + ": " + text
    }()
    
    /// 是否显示原创中的贴图
    var isShowChartlet : Bool  {
        guard let pic_urls = self.pic_urls_ViewMode where pic_urls.count > 0 else {
            return false
        }
        return true
    }
    
    /// 判断是否是转发
    var isForward : Bool {
        return modeSource?.retweeted_status != nil ? true : false
    }
    
    //MARK:- frame计算
    /// cell高度计算
    lazy var height : CGFloat = {
        
        var t_height = self.topHight + MZCMargin + self.bottomHight + MZCMinMargin
        
        if self.isForward {
            /// 是转发  +转发高度 +间距
            /// 不是转发 + 0
            t_height = t_height + self.forwardViewFrame.size.height + MZCMargin
        }else{
            /// 有原创贴图 +原创贴图高度 +间距
            /// 没有原创贴图 +0
            let centersHeight = self.centersSize.contentSize.height
            t_height = self.isShowChartlet ? t_height + centersHeight + MZCMargin : t_height
        }
        /// cell 间距
        t_height = t_height + MZCMargin
        return t_height
    }()
    
    /// 计算cell top高度
    lazy var topHight : CGFloat = {
        let screenW = UIScreen.mainScreen().bounds.size.width
        var t_topHight : CGFloat = 0
        let textMaxW = screenW - MZCMargin * 3 - MZCHeadIconWH
        
        if self.modeSource!.text!.characters.count > 0 {
            let size = self.modeSource!.text!.mzc_stringSize(width: textMaxW)
            t_topHight = MZCMargin * 2 + MZCHeadIconWH + size.height
        }else{
            t_topHight = MZCMargin + MZCHeadIconWH
        }
        return t_topHight
    }()
    
    
    /// 计算cell bottom高度
    private lazy var bottomHight : CGFloat = {
        return MZCTopicTabBarH
    }()
    
    /// 贴图视图大小
    lazy var centersSize : (itemSize : CGSize, contentSize : CGSize) = {
        
        let count = self.pic_urls_ViewMode?.count ?? 0
        /*
         没有配图: cell = zero, collectionview = zero
         一张配图: cell = image.size, collectionview = image.size
         四张配图: cell = {90, 90}, collectionview = {2*w+m, 2*h+m}
         其他张配图: cell = {90, 90}, collectionview =
         */
        var itemSize : CGSize = CGSizeZero
        var contentSize : CGSize = CGSizeZero
        
        if count == 1 {
            let urlStr = self.pic_urls_ViewMode?.first?.absoluteString
            let img = YYWebImageManager.sharedManager().cache?.getImageForKey(urlStr!)
            guard let t_img = img else{
                return (itemSize,contentSize)
            }
            itemSize = t_img.size
            contentSize = t_img.size
            return (itemSize,contentSize)
        }
        
        if count == 4{
            itemSize = CGSizeMake(MZCTopicBoxWH, MZCTopicBoxWH)
            let contentW = itemSize.width * 2 + MZCMinMargin
            let contentH = itemSize.height * 2 + MZCMinMargin
            contentSize = CGSizeMake(contentW, contentH)
            return (itemSize,contentSize)
        }
        
        let col : Int = 3
        let row : Int = (count - 1) / col + 1
        itemSize = CGSizeMake(MZCTopicBoxWH, MZCTopicBoxWH)
        let contentW = CGFloat(col) * itemSize.width + (CGFloat(col) - 1)
        let contentH = CGFloat(row) * itemSize.height + (CGFloat(row) - 1)
        contentSize = CGSizeMake(contentW, contentH)
        
        
        return (itemSize,contentSize)
        
        
    }()
    //MARK:- 设置转发视图大小
     lazy var forwardViewFrame : CGRect = {
        
        let screenW = UIScreen.mainScreen().bounds.size.width
        let x : CGFloat = 0
        let y : CGFloat = self.topHight + MZCMargin
        let width = screenW
        var height : CGFloat = 0.0
        /// 如果有内容 + 内容高度
        if let text = self.source_forward_ViewMode {
            let textMaxWidth = MZCTopicContentMAXWidth
            height = text.mzc_stringSize(width: textMaxWidth).height + MZCMargin
        }
        /// 如果有贴图 + 贴图高度
        if self.isShowChartlet {
            height = height + self.centersSize.contentSize.height + MZCMargin
        }
        
        
        return CGRectMake(x, y, width, height)
    }()
    //MARK:- 原创视图大小
    lazy var originalChartletViewFrame : CGRect = {
        
        let x = MZCMargin * 2 + MZCHeadIconWH
        
        let y = self.topHight + MZCMargin
        
        let size = self.centersSize.contentSize
        
        return CGRectMake(x, y, size.width, size.height)
    }()
    
    //MARK:- 初始化
    convenience init(mode : MZCHomeMode?)
    {
        
        self.init()
        
        guard let t_mode = mode else {
            return
        }
        
        if t_mode.user == nil {
            return
        }
        
        modeSource = t_mode
        
    }
}

