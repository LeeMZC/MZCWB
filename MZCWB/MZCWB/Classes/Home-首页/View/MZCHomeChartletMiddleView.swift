//
//  MZCHomeChartletMiddleView.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/7.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

class MZCHomeChartletMiddleView: UIView {

    @IBOutlet weak var chartletCollectionView: MZCHomeChartletCollectionView!
    
    class func chartletMiddleView() -> MZCHomeChartletMiddleView {
        return NSBundle.mainBundle().loadNibNamed("MZCHomeChartletMiddleView", owner: nil, options: nil).last as! MZCHomeChartletMiddleView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        autoresizingMask = .None
    }
    
    var mode : MZCHomeViewMode? {
        didSet {
            chartletCollectionView.mode = mode
        }
    }
}
