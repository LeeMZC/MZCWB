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
            
            // 添加中等图,用于图片浏览
            var urlStr_ns = (urlStr as NSString).stringByReplacingOccurrencesOfString("thumbnail", withString: "mw690")
            let urlMiddlePic = NSURL(string: urlStr_ns as String)
            self.pic_urls_middle_ViewMode.append(urlMiddlePic!)
            
        }
        
        return urls

        
    }()
    
    var pic_urls_middle_ViewMode : [NSURL] = []
    
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
        
        return self.topHight + self.middleHight + self.bottomHight + MZCMargin
        
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
        t_topHight += MZCMargin
        return t_topHight
    }()
    
    /// 计算中间高度
    private lazy var middleHight : CGFloat = {
        
        var height : CGFloat = 0.0
        /// 转发文字高度
        if let text = self.source_forward_ViewMode {
            let textMaxWidth = MZCTopicContentMAXWidth
            height = text.mzc_stringSize(width: textMaxWidth).height + MZCMargin * 2
        }
        /// 贴图高度
        if self.isShowChartlet {
            let count = self.pic_urls_ViewMode?.count ?? 0
            
            switch count {
            case 1:
                let urlStr = self.pic_urls_ViewMode?.first?.absoluteString
                let img = YYWebImageManager.sharedManager().cache?.getImageForKey(urlStr!)
                
                if let t_img = img {
                    height += (t_img.size.height + MZCMargin)
                }else {
                    height = 0
                }
                
            case 4:
                height += (MZCTopicBoxWH * 2 + MZCMargin + MZCMinMargin)
            default:
                
                let col : Int = 3
                let row : Int = (count - 1) / col + 1
                height += (CGFloat(row) * MZCTopicBoxWH + ((CGFloat(row) - 1)) * MZCMinMargin) 
                
                height += MZCMargin
                break
            }
            
        }
        /**
         *  补齐差值
         */
        height += 0.5
        return height
    }()
    
    /// 计算cell bottom高度
    private lazy var bottomHight : CGFloat = {
        return MZCTopicTabBarH
    }()
    
    /// 中间视图frame
    lazy var middleFrame : CGRect = {
        
        let poi_x : CGFloat = 0.0
        let poi_y : CGFloat = self.topHight
        let width : CGFloat = MZCScreenSize.width
        var height : CGFloat = self.middleHight
        
        return CGRectMake(poi_x, poi_y, width, height)
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

