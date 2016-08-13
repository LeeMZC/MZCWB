//
//  MZCHomeTableViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/20.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
import SwiftyJSON
import YYWebImage
import MJRefresh

private let Identifier = "HomeCell"

public enum MZCRequestDataState : Int {
    
    /// 普通状态
    case normal
    /// 请求新数据状态
    case newData
    /// 请求老数据状态
    case oldData
}

class MZCHomeTableViewController: UITableViewController {
    
    
    
    //MARK:- 属性
    var requestDataState = MZCRequestDataState.normal
    
    var homeDataArr : [MZCHomeViewMode] = [] {
        didSet{
            dispatch_async(dispatch_get_main_queue(), { [weak self] () in
                
                guard let weakSelf = self else {return }
                
                let oldCount = oldValue.count ?? 0
                let newIdCount = weakSelf.homeDataArr.count ?? 0
                weakSelf.noMoreDataTipsView.ani(newIdCount - oldCount)
                
                weakSelf.endRefreshing()
                
                weakSelf.tableView.reloadData()
                
            })
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        QL1("")
        setupUI()
    }
    
    //MARK: did
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK:- didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        homeDataArr.removeAll()
    }
    
    //MARK:- setup
    func setupUI(){
        setupNotification()
        registerCell()
        setupNavUI()
        setupTabViewUI()
        setupLoadData()
        
        
    }
    
    private func setupNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MZCHomeTableViewController.pictureWillShow(notice:)), name: MZCPictureWillShow, object: nil)
    }
    
    private func setupLoadData(){
        self.tableView.mj_header = MZCRefreshStateHeader {[weak self] () in
            guard let weakSelf = self else {return }
            if weakSelf.requestDataState != MZCRequestDataState.normal {return }
            weakSelf.loadNewData()
        }
        self.tableView.mj_header.beginRefreshing()
        
        self.tableView.mj_footer = MZCRefreshAutoFooter(refreshingBlock: {[weak self] () in
            guard let weakSelf = self else {return }
            if weakSelf.requestDataState != MZCRequestDataState.normal {return }
            weakSelf.loadOldData()
            })
    }
    
    private func setupTabViewUI(){
        let view = UIView()
        view.bounds = tableView.bounds
        view.backgroundColor = UIColor.grayColor()
        tableView.backgroundView = view
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
    
    }
    
    //MARK:- private 注册cell
    private func registerCell(){
        let cellNib = UINib(nibName: "MZCHomeTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: Identifier)
    }
    
    //MARK:- 加载更多数据
    private var since_id : String {
        return homeDataArr.first?.modeSource?.idstr ?? "0"
    }
    
    private var max_id : String {
        let t_idstr = homeDataArr.last?.modeSource?.idstr ?? "0"
        var idstr = ""
        if t_idstr != "0" {
            idstr = "\(Int(t_idstr)! - 1)"
        }else{
            idstr = "0"
        }
        
        return idstr
    }
    
    private func loadNewData(){
        requestDataState = MZCRequestDataState.newData
        let access_token = accountTokenMode!.access_token!
        let parameters = ["access_token": access_token,
                          "since_id" : since_id]
        
        loadData(parameters: parameters)
    }
    
    private func loadOldData(){
        requestDataState = MZCRequestDataState.oldData
        let access_token = accountTokenMode!.access_token!
        let parameters = ["access_token": access_token,
                          "max_id" : max_id]
        
        loadData(parameters: parameters)
    }
    
    private func loadData(parameters aParameters : [String : String]){
        MZCAlamofire.shareInstance.homeLoadData(parameters: aParameters) {[weak self] (datas, error) in
            guard let weakSelf = self else {return }
            
            if error != nil {
                weakSelf.endRefreshing()
                return
            }
            
            guard let t_datas = datas else {
                weakSelf.endRefreshing()
                return
            }
            
            var t_homeModeArr = [MZCHomeViewMode]()
            for dict in t_datas {
                
                let homeMode = MZCHomeMode(dict: dict)
                
                t_homeModeArr.append(MZCHomeViewMode(mode: homeMode))
            }
            
            weakSelf.cachesImages(t_homeModeArr)
        }
    }
    
    //MARK:- 结束刷新
    private func endRefreshing(){
    
        switch self.requestDataState {
        case .newData:
            tableView.mj_header.endRefreshing()
        case .oldData:
            tableView.mj_footer.endRefreshing()
        default:
            break
        }
        
        requestDataState = MZCRequestDataState.normal
        
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
            
            switch self.requestDataState {
            case .newData:
                self.homeDataArr = modes + self.homeDataArr
            case .oldData:
                self.homeDataArr = self.homeDataArr + modes
            default:
                break
            }
        }
        
    }
    //MARK:- 弹出加载完成提示
    private lazy var noMoreDataTipsView : MZCNoMoreDataTipsView = {
        let navBarView = self.navigationController?.navigationBar
        let frame = navBarView?.bounds
        let view = MZCNoMoreDataTipsView(frame: frame!)
        navBarView?.insertSubview(view, atIndex: 0)
        return view
    }()
    
    //MARK:- 设置navigationUI
    private func setupNavUI(){
        QL1("")
        navigationItem.leftBarButtonItem = UIBarButtonItem(imgName: "navigationbar_friendattention", target: self, action: #selector(MZCHomeTableViewController.leftDidOnClick));
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imgName: "navigationbar_pop", target: self, action: #selector(MZCHomeTableViewController.rightDidOnClick));
        
        let titleView = MZCHomeTitleButton()
        navigationItem.titleView = titleView
        titleView.addTarget(self, action: #selector(MZCHomeTableViewController.titleDidOnClick(titleBtn:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    //MARK:- 用户信息动画代理对象
    private lazy var userInfoPopManager : MZCHomeUserInfoPresentationController = {
        //1. 创建转场对象
        let popManager = MZCHomeUserInfoPresentationController()
        popManager.dataSource = self
        return popManager
    }()
    
    //MARK:- 点击微博图片转场动画
    private lazy var imageBrowserPopManager : MZCHomePopImageBrowserPresentationController = {
        //1. 创建转场对象
        let popManager = MZCHomePopImageBrowserPresentationController()
        return popManager
    }()

}

// MARK:- delegate
extension MZCHomeTableViewController : MZCHomeUserInfoDataSource{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeDataArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MZCHomeTableViewCell {
        
        let homeCell = tableView.dequeueReusableCellWithIdentifier(Identifier, forIndexPath: indexPath) as! MZCHomeTableViewCell
        
        let homeViewMode = homeDataArr[indexPath.row]
        
        homeCell.mode = homeViewMode
//        homeCell.backgroundColor = MZCRandomColor

        return homeCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let homeViewMode = homeDataArr[indexPath.row]
        return homeViewMode.height
    }
    
    func userInfoPresentationControllerRect() -> CGRect {
        let mainScreenframe = UIScreen.mainScreen().bounds
        let width = mainScreenframe.size.width / 2
        let height = mainScreenframe.size.height / 3
        let x = (mainScreenframe.size.width - width) / 2
        return CGRectMake(x, 64,width , height)
    }

}

// MARK:- 事件
extension MZCHomeTableViewController{
    @objc private func leftDidOnClick(){
        
    }
    
    @objc private func rightDidOnClick(){
        QL1("")        
        let scanViewController = UINavigationController(rootViewController: MZCScanViewController())
        
        presentViewController(scanViewController, animated: true, completion: nil)
    }
    
    @objc private func titleDidOnClick(titleBtn aDeTitleBtn : MZCHomeTitleButton){
        QL1("")
        //1. 创建视图
        let presentationView = MZCHomePopViewController()
        //2. 设置视图转场代理
        
        presentationView.transitioningDelegate = userInfoPopManager
        
        //3. 设置视图转场样式
        presentationView.modalPresentationStyle = UIModalPresentationStyle.Custom
        //4. modal窗口
        presentViewController(presentationView, animated: true, completion: nil)
        
    }
    
    @objc private func pictureWillShow(notice aNotice: NSNotification){
        QL1("")
        guard let urls = aNotice.userInfo!["bmiddle_pic"] where (urls as! [NSURL]).count > 0 else {
            return
        }
    
        guard let indexPath = aNotice.userInfo!["indexPath"] else {
            return
        }
        
        imageBrowserPopManager.dataSource = aNotice.object as! MZCHomeChartletCollectionView
        
        let viewController = MZCHomeImageBrowserViewController(bmiddle_pic: urls as! [NSURL], indexPath: indexPath as! NSIndexPath)
        
        
        viewController.transitioningDelegate = imageBrowserPopManager
        
        //3. 设置视图转场样式
        viewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        /**
         *  弹出图片浏览器
         */
        dispatch_async(dispatch_get_main_queue()) { 
            self.presentViewController(viewController, animated: true, completion: nil)
        }
        
        
    }
}