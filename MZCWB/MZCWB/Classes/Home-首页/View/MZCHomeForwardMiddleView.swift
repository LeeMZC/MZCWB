
//
//  MZCHomeForwardMiddleView.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/7.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import YYKit
class MZCHomeForwardMiddleView: UIView {

    @IBOutlet weak var bottomMarginCollectionView: NSLayoutConstraint!

    @IBOutlet weak var source_forward_label: YYLabel!
    
    @IBOutlet weak var chartletCollectionView: MZCHomeChartletCollectionView!
    
    
    class func forwardMiddleView() -> MZCHomeForwardMiddleView {
        return NSBundle.mainBundle().loadNibNamed("MZCHomeForwardMiddleView", owner: nil, options: nil).last as! MZCHomeForwardMiddleView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = UIViewAutoresizing.None

    }
    
    var mode : MZCHomeViewMode? {
        didSet {
            if let layout = mode!.textLayout_forward_ViewMode {
                
                source_forward_label.size = layout.textBoundingSize
                source_forward_label.textLayout = layout
                source_forward_label.preferredMaxLayoutWidth = MZCTopicContentMAXWidth
                
            }else{
                source_forward_label.textLayout = nil
            }
            
            if !mode!.isShowChartlet {
                bottomMarginCollectionView.constant = 0
            }else{
                bottomMarginCollectionView.constant = 10
            }
            
            chartletCollectionView.mode = mode
        }
    }
}
