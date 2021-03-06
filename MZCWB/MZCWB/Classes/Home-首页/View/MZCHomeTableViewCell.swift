//
//  MZCHomeTableViewCell.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/30.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import YYKit
import QorumLogs


class MZCHomeTableViewCell: UITableViewCell {

    //MARK:- 属性
    /// 用户头像（中图），50×50像素
    @IBOutlet weak var profile_image_url_ImageView: UIImageView!
    /// 用户名称
    @IBOutlet weak var screen_name_Label: UILabel!
    /// 用户认证类型
    @IBOutlet weak var verified_type_ImageView: UIImageView!
    /// 会员等级 ,取值范围 1~6
    @IBOutlet weak var mbrank_ImageView: UIImageView!
    /// 微博创建时间
    @IBOutlet weak var created_at_Label: UILabel!
    /// 微博来源
    @IBOutlet weak var source_Label: UILabel!
    /// 微博信息内容
    
    @IBOutlet weak var text_Label: YYLabel!
    
    
    
    //MARK:- setMode
    var mode : MZCHomeViewMode? {
        didSet{
            
            guard let t_mode = mode else {
                return
            }
            profile_image_url_ImageView.setImageWithURL(mode!.profile_image_url_ViewMode, placeholderImage: UIImage.init(named: "avatar_default_small"))
            profile_image_url_ImageView.layer.cornerRadius = profile_image_url_ImageView.frame.size.width / 2
            profile_image_url_ImageView.layer.masksToBounds = true
            
            screen_name_Label.text = t_mode.modeSource!.user!.screen_name
            
            verified_type_ImageView.image = t_mode.verified_type_ViewMode
            
            mbrank_ImageView.image = t_mode.mbrank_ViewMode
            
            created_at_Label.text = t_mode.created_at_ViewMode
            
            source_Label.text = t_mode.source_ViewMode
            
            text_Label.size = t_mode.textLayout_ViewMode.textBoundingSize
            text_Label.textLayout = t_mode.textLayout_ViewMode
            
            
            /// 是否是转发
            if t_mode.isForward {
                chartletMiddleView.hidden = true
                forwardMiddleView.hidden = false
                forwardMiddleView.frame = t_mode.middleFrame
                forwardMiddleView.mode = t_mode
            }else {
                forwardMiddleView.hidden = true
                chartletMiddleView.hidden = false
                chartletMiddleView.frame = t_mode.middleFrame
                chartletMiddleView.mode = t_mode
            }
            
        }
    }
    //MARK:- 创建原创贴图视图
    private lazy var chartletMiddleView : MZCHomeChartletMiddleView = {
        let view = MZCHomeChartletMiddleView.chartletMiddleView()
        self.addSubview(view)
        return view
    }()
    
    
    //MARK:- 创建转发视图
    private lazy var forwardMiddleView : MZCHomeForwardMiddleView = {
        let view = MZCHomeForwardMiddleView.forwardMiddleView()
        self.addSubview(view)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI(){
        /**
         *  原创内容如果有内容设置内容最大宽度
         */
//        if text_Label.text?.characters.count > 0 {
            text_Label.preferredMaxLayoutWidth = MZCTopicContentMAXWidth
//        }

    }
    //MARK:- 设置Cell间距 拦截frame
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.size.height -= MZCMargin
            super.frame = newFrame
        }
    }
    
}

