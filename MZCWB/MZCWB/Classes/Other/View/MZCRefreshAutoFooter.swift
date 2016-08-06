//
//  MZCRefreshAutoFooter.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/6.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import MJRefresh
class MZCRefreshAutoFooter: MJRefreshAutoFooter {

    override func prepare() {
        super.prepare()
        triggerAutomaticallyRefreshPercent = -2.0
        mj_h = 0.01
        backgroundColor = UIColor.greenColor()
        self.automaticallyHidden = true;
    }

}
