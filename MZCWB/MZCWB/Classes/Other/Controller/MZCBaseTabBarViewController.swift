//
//  MZCBaseTabBarViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/26.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

class MZCBaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        barButtonItemConfig()
        
        setupTabBarController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func barButtonItemConfig(){
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = UIColor.orangeColor()
    }
    
    private func setupTabBarController(){
        setValue(MZCTabBarView(), forKey: "tabBar")
    }
    
    
    func createClass(className : String) -> UIViewController{
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
    
    
    func add4ChildViewController(vcArr : Array<UIViewController>) {
        
        addChildViewController(vcArr[0], title: "首页", imgName: "tabbar_home")
        
        addChildViewController(vcArr[1], title: "消息", imgName: "tabbar_message_center")
        
        addChildViewController(vcArr[2], title: "发现", imgName: "tabbar_discover")
        
        addChildViewController(vcArr[3], title: "我", imgName: "tabbar_profile")
    }
    
    func addChildViewController(viewController: UIViewController,title : String,imgName : String ) {
        
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

