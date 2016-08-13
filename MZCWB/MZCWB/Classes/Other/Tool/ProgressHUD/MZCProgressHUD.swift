//
//  MZCProgressHUD.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/12.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import SVProgressHUD
class MZCProgressHUD: SVProgressHUD {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.minimumDismissTimeInterval = 2.0
        self.defaultMaskType = SVProgressHUDMaskType.Black
        self.fadeInAnimationDuration = 0.5
        self.fadeOutAnimationDuration = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
