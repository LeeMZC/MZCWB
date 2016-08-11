//
//  MZCTabBarController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/20.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

class MZCTabBarController: MZCBaseTabBarViewController {
    
    private var isLogin = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

    
    //MARK:- 设置登录后UI
    private func setupUI() {
        
        guard let tempDatas = self.datas else{
            addDefaultSubController()
            return
        }

        addNetWorkDataController(tempDatas)
        
//        let tabBar = self.tabBar as! MZCTabBarView
//        tabBar.messageDelegate = self
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


