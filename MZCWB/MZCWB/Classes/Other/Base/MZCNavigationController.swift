//
//  MZCNavigationController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/23.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs

var onceToken = dispatch_once_t()

class MZCNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        dispatch_once(&onceToken) { 
            self.navConfig()
        }
    }
    
    private func navConfig(){
        let barItem = UIBarButtonItem.appearance()
        barItem.tintColor = UIColor.orangeColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
