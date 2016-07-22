//
//  MZCTabBarController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/20.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

class MZCTabBarController: UITabBarController {
    
//    override func loadView() {
//        self.view = MZCTabBarView()
//    }
    
    private var isLogin = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barButtonItemConfig()
        
        isLogin ? setupUI() : setupLoginUI()
        
        
    }
    
    //MARK:- layz datas
    private var datas : Array<Dictionary<String,String>>? {
        
        guard let dataPaht = NSBundle.mainBundle().pathForResource("MainVCSettings", ofType: "json") else{
            return nil
        }
        
        guard let data = NSData(contentsOfFile : dataPaht) else{
            return nil
        }
        
        do{
            guard let arr = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? Array<Dictionary<String, String>> else{
                return nil
            }
            
            return arr
        }catch{
            return nil
        }
    }
    
    private func barButtonItemConfig(){
        
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = UIColor.orangeColor()
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
    
    //MARK:- 设置登录后UI
    private func setupUI() {
        
        guard let tempDatas = self.datas else{
            addDefaultSubController()
            return
        }
        
        addNetWorkDataController(tempDatas)
        
        setupTabBarController()
        
    }
    
    private func setupTabBarController(){
        setValue(MZCTabBarView(), forKey: "tabBar")
    }
    
    private func addDefaultSubController(){
        let homeViewController = createClass("MZCHomeTableViewController")
        let messageViewController = createClass("MZCMessageTableViewController")
        let plazaViewController = createClass("MZCPlazaTableViewController")
        let meViewController = createClass("MZCMeTableViewController")
        
        let vcArr = [homeViewController,messageViewController,plazaViewController,meViewController]
        
        add4ChildViewController(vcArr)
    }
    
    private func addNetWorkDataController(datas : Array<Dictionary<String,String>>){
        for dict in datas {
            
            guard let clsName = dict["vcName"] else{
                return
            }
            
            guard let title = dict["title"] else{
                return
            }
            
            guard let imgName = dict["imageName"] else{
                return
            }
            
            addChildViewController(createClass(clsName), title: title, imgName: imgName)
        }
    }
    
    
}


//MARK:- 添加控制器扩展
extension MZCTabBarController{
    //MARK: 根据类名创建对象
    private func createClass(className : String) -> UIViewController{
        guard let bundleName = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else{
            return UIViewController()
        }
        let namespace_className = bundleName + "." + className;
        
        let cls : AnyObject? = NSClassFromString(namespace_className)
        guard let viewController = cls as? UIViewController.Type else{
            return UIViewController()
        }
        
        return viewController.init()
    }
    
    
    
    private func add4ChildViewController(vcArr : Array<UIViewController>) {
        
        addChildViewController(vcArr[0], title: "首页", imgName: "tabbar_home")
        
        addChildViewController(vcArr[1], title: "消息", imgName: "tabbar_message_center")
        
        addChildViewController(vcArr[2], title: "发现", imgName: "tabbar_discover")
        
        addChildViewController(vcArr[3], title: "我", imgName: "tabbar_profile")
    }
    
    private func addChildViewController(viewController: UIViewController,title : String,imgName : String ) {
        
        //标题
        viewController.title = title
        //图片
        viewController.tabBarItem.image = UIImage.init(named: imgName)
        //选中图片
        viewController.tabBarItem.selectedImage = UIImage.init(named: imgName + "_highlighted")
        
        let nav = MZCNavigationController(rootViewController: viewController)
        
        addChildViewController(nav)
        
    }
}
