//
//  MZCScanNavViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/23.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

class MZCScanNavViewController: UIViewController {
    
    override func loadView() {
        view = NSBundle.mainBundle().loadNibNamed("MZCScanView", owner: nil, options: nil).last as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupNavUI(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "扫一扫", style: UIBarButtonItemStyle.Done, target: self, action: #selector(MZCScanNavViewController.exit))
        
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

extension MZCScanNavViewController{
    
    @objc private func exit(){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
