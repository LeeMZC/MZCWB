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
    
    private var isLogin = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.greenColor()
        //字体颜色
        tabBar.tintColor = UIColor.orangeColor()
        
        
        isLogin ? setupUI() : setupLoginUI()

    }
    
    //MARK:- layz datas
    var datas : Array<Dictionary<String,String>>? {
        
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
    
    //MARK:- 添加子控制器
    private func setupUI() {
        
        guard let tempDatas = self.datas else{
            
            
            let homeViewController = createClass("MZCHomeTableViewController")
            let messageViewController = createClass("MZCMessageTableViewController")
            let plazaViewController = createClass("MZCPlazaTableViewController")
            let meViewController = createClass("MZCMeTableViewController")
            
            let vcArr = [homeViewController,messageViewController,plazaViewController,meViewController]
            
            add4ChildViewController(vcArr)
            
            return
        }
        
        for dict in tempDatas {
            
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
    
    
    private func addChildViewController(viewController: UIViewController,title : String,imgName : String ) {
        
        //标题
        viewController.title = title
        //图片
        viewController.tabBarItem.image = UIImage.init(named: imgName)
        //选中图片
        viewController.tabBarItem.selectedImage = UIImage.init(named: imgName + "_highlighted")
        
        let nav = UINavigationController(rootViewController: viewController)
        
        addChildViewController(nav)
        
    }
    
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
    
    //MARK:login登录界面
    private func setupLoginUI(){
        let homeViewController = MZCLoginViewController(type: MZCViewControllerType.MZCHome)
        let messageViewController = MZCLoginViewController(type: MZCViewControllerType.MZCMessage)
        let plazaViewController = MZCLoginViewController(type: MZCViewControllerType.MZCPlaza)
        let meViewController = MZCLoginViewController(type: MZCViewControllerType.MZCMe)
        
        let vcArr = [homeViewController,messageViewController,plazaViewController,meViewController]
        
        add4ChildViewController(vcArr)
    }
    
    func add4ChildViewController(vcArr : Array<UIViewController>) {
        
        addChildViewController(vcArr[0], title: "首页", imgName: "tabbar_home")
        
        addChildViewController(vcArr[1], title: "消息", imgName: "tabbar_message_center")
        
        addChildViewController(vcArr[2], title: "发现", imgName: "tabbar_discover")
        
        addChildViewController(vcArr[3], title: "我", imgName: "tabbar_profile")
    }

}