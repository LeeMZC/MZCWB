//
//  MZCHomeTableViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/20.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCHomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavUI()
    }
    
    //MARK:- 设置navigationUI
    private func setupNavUI(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(imgName: "navigationbar_friendattention", target: self, action: #selector(MZCHomeTableViewController.leftDidOnClick));
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imgName: "navigationbar_pop", target: self, action: #selector(MZCHomeTableViewController.rightDidOnClick));
        
        let titleView = MZCHomeTitleButton()
        navigationItem.titleView = titleView
        titleView.addTarget(self, action: #selector(MZCHomeTableViewController.titleDidOnClick(titleBtn:)), forControlEvents: UIControlEvents.TouchUpInside)
    }

    

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    //MARK:- 过场动画代理对象
    private lazy var presentAnimation : MZCBaseTransition = {
        //1. 创建转场对象
        let mainScreenframe = UIScreen.mainScreen().bounds
        let width = mainScreenframe.size.width / 2
        let height = mainScreenframe.size.height / 3
        let x = (mainScreenframe.size.width - width) / 2
        
        let frame = CGRectMake(x, 64,width , height)
        return MZCHomePopTransition(presentFrame: frame)
    }()

}

// MARK:- 事件
extension MZCHomeTableViewController{
    @objc private func leftDidOnClick(){
        QL1("")
    }
    
    @objc private func rightDidOnClick(){
        
        let scanViewController = UINavigationController(rootViewController: MZCScanViewController())
        
        presentViewController(scanViewController, animated: true, completion: nil)
    }
    
    @objc private func titleDidOnClick(titleBtn aDeTitleBtn : MZCHomeTitleButton){
        
        //1. 创建视图
        let presentationView = MZCHomePopViewController()
        //2. 设置视图转场代理
        
        presentationView.transitioningDelegate = self.presentAnimation
        //3. 设置视图转场样式
        presentationView.modalPresentationStyle = UIModalPresentationStyle.Custom
        //4. modal窗口
        presentViewController(presentationView, animated: true, completion: nil)
        
    }
}