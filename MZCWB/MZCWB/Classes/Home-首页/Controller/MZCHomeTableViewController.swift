//
//  MZCHomeTableViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/20.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
import Rswift
import SwiftyJSON
import YYWebImage

private let Identifier = "HomeCell"

class MZCHomeTableViewController: UITableViewController {

    //MARK:- 属性
    var homeDataArr : [MZCHomeViewMode] = [] {
        didSet{
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        registerCell()
        setupNavUI()
        loadData()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    //MARK:- private 注册cell
    private func registerCell(){
        let cellNib = UINib(nibName: "MZCHomeTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: Identifier)
    }
    
    //MARK: 加载数据
    private func loadData(){
        MZCAlamofire.shareInstance.homeLoadData { (datas, error) in
            
            if error != nil {return}
            
            guard let t_datas = datas else {
                return
            }
            
            var t_homeModeArr = [MZCHomeViewMode]()
            for dict in t_datas {
                
                let homeMode = MZCHomeMode(dict: dict)
            
                t_homeModeArr.append(MZCHomeViewMode(mode: homeMode))
            }
            
            self.cachesImages(t_homeModeArr)

        }
    }
    //MARK:- 缓存贴图img
    private func cachesImages(modes : [MZCHomeViewMode]) {
        
        let group = dispatch_group_create()
        
        for mode in modes {
            
            guard let urls = mode.pic_urls_ViewMode where urls.count > 0 else {
                continue
            }
            
            for url in urls {
                dispatch_group_enter(group)
                
                YYWebImageManager.sharedManager().requestImageWithURL(url, options: YYWebImageOptions.RefreshImageCache, progress: { (currentCount : Int, toteCount : Int) in
                    
                    }, transform: { (img : UIImage, url:NSURL) -> UIImage? in
                        return img
                }) { (img:UIImage?, url:NSURL, type:YYWebImageFromType, stage:YYWebImageStage,error: NSError?) in
                    //导致显示延迟问题
//                    dispatch_group_leave(group)
                }
                //解决显示延迟问题
                dispatch_group_leave(group)
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            self.homeDataArr = modes
        }
    }
    
    //MARK: 设置navigationUI
    private func setupNavUI(){
        QL1("")
        navigationItem.leftBarButtonItem = UIBarButtonItem(imgName: "navigationbar_friendattention", target: self, action: #selector(MZCHomeTableViewController.leftDidOnClick));
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imgName: "navigationbar_pop", target: self, action: #selector(MZCHomeTableViewController.rightDidOnClick));
        
        let titleView = MZCHomeTitleButton()
        navigationItem.titleView = titleView
        titleView.addTarget(self, action: #selector(MZCHomeTableViewController.titleDidOnClick(titleBtn:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    //MARK: 过场动画代理对象
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

// MARK:- delegate
extension MZCHomeTableViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeDataArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MZCHomeTableViewCell {
        
        let homeCell = tableView.dequeueReusableCellWithIdentifier(Identifier, forIndexPath: indexPath) as! MZCHomeTableViewCell
        
        let homeViewMode = homeDataArr[indexPath.row]
        
        homeCell.mode = homeViewMode

        return homeCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let homeViewMode = homeDataArr[indexPath.row]
        return homeViewMode.height
    }
    

}

// MARK:- 事件
extension MZCHomeTableViewController{
    @objc private func leftDidOnClick(){
        
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