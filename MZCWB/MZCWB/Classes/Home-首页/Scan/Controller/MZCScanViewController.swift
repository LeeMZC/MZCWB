//
//  MZCScanViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/23.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCScanViewController: UIViewController {

    @IBOutlet weak var scanTabBar: UITabBar!
    //记录上一次点击的item
    private var oldSelectItem : UITabBarItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private let titleEdgeInsets = 20.0

    private func setupUI(){
        
        setupNavItem()
        
        setupTabBar()
        
        setupScanAniView()
        
    }
    
    //MARK:- Nav
    private func setupNavItem(){
        let leftButton = UIButton(imgName: nil, titleString: "退出", target: self, action: #selector(MZCScanViewController.leftDidOnclick))
        buttonFrameAndColor(leftButton)
        leftButton.titleEdgeInsets.right = CGFloat(titleEdgeInsets)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let rightButton = UIButton(imgName: nil, titleString: "相册", target: self, action: #selector(MZCScanViewController.rightDidOnClick))
        buttonFrameAndColor(rightButton)
        rightButton.titleEdgeInsets.right = CGFloat(titleEdgeInsets)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    private func buttonFrameAndColor(button : UIButton){
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted)
        button.sizeToFit()
        button.bounds.size.width += (CGFloat)(titleEdgeInsets)
    }
    
    //MARK:- TabBar
    private func setupTabBar(){
        scanTabBar.delegate = self
        scanTabBar.selectedItem = scanTabBar.items?.first
        oldSelectItem = scanTabBar.selectedItem
    }
    
    
    
    //MARK:- scanAniView
    private func setupScanAniView(){
        self.scanAniView.startAni()
        
    }
    
    private lazy var scanAniView : MZCScanAniView = {
        let scanAniView = MZCScanAniView.scanAniView()
        
        self.view.addSubview(scanAniView)
        scanAniView.setNeedsLayout()
        return scanAniView
    }()
    
}

//MARK:- event
extension MZCScanViewController{
    
    @objc private func leftDidOnclick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func rightDidOnClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK:- delegate
extension MZCScanViewController : UITabBarDelegate{
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        if oldSelectItem == item {
            return
        }
        
        oldSelectItem = item
        scanAniView.imgHight = scanTabBar.items?.first == item ? 200 : 100
        scanAniView.startAni()
    }
}
