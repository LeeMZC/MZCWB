//
//  MZCLoginTabBarViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/26.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCLoginTabBarViewController: MZCBaseTabBarViewController {

    override func viewDidLoad() {
        QL1("")
        super.viewDidLoad()

        setupLoginUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:login登录界面
    private func setupLoginUI(){
        let homeViewController = MZCLoginViewController(type: MZCViewControllerType.MZCHome)
        let messageViewController = MZCLoginViewController(type: MZCViewControllerType.MZCMessage)
        let plazaViewController = MZCLoginViewController(type: MZCViewControllerType.MZCPlaza)
        let meViewController = MZCLoginViewController(type: MZCViewControllerType.MZCMe)
        
        let vcArr = [homeViewController,messageViewController,plazaViewController,meViewController]
        
        add4ChildViewController(vcArr)
    }

}
