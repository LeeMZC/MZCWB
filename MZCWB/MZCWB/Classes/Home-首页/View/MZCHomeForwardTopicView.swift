//
//  MZCHomeForwardTopicView.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/1.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import YYWebImage
class MZCHomeForwardTopicView: UIView {

    @IBOutlet weak var source_forward_label: UILabel!

    @IBOutlet weak var forwardChartletCollectionView: MZCHomeChartletCollectionView!
    
//    @IBOutlet weak var forwardChartletViewLayout: MZCHomeChartViewLayout!
    
    
    class func forwardTopicView() -> MZCHomeForwardTopicView {
       return NSBundle.mainBundle().loadNibNamed("MZCHomeForwardTopicView", owner: nil, options: nil).last as! MZCHomeForwardTopicView
    }
    //MARK:- 根据mode设置转发视图UI 在cell的set方法中
    func forwardSetupUI(mode : MZCHomeViewMode){
        frame = mode.forwardViewFrame
        
        if let text = mode.source_forward_ViewMode {
            source_forward_label.text = text
            source_forward_label.preferredMaxLayoutWidth = MZCTopicContentMAXWidth
        }else{
            source_forward_label.text = nil
        }
        
        forwardChartletCollectionView.chartletSetupUI(mode, isOriginal: false)
    }
}




