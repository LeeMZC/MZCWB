//
//  MZCHTTPSessionManager.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/25.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire
import SwiftyJSON
import QorumLogs
class MZCHTTPSessionManager: AFHTTPSessionManager {
    // Swift推荐我们这样编写单例
    static let shareInstance: MZCHTTPSessionManager = {
        
        // 注意: baseURL后面一定更要写上./
//        let baseURL = NSURL(string: "https://api.weibo.com/")!
        // 单例对象
//        let instance = MZCHTTPSessionManager(baseURL: baseURL, sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let instance = MZCHTTPSessionManager()
        
        // 配置可解析数据类型
        instance.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/json", "text/javascript", "text/plain") as? Set
        
        
        return instance
    }()
}

class MZCAlamofire : NSObject{
    
    static let shareInstance: MZCAlamofire = MZCAlamofire()
    
    //MARK:- 登录获取令牌
    func AccountToKen(code : String , finished : (tokenDic: AnyObject? , userDic: AnyObject?, error: NSError?)->()){
        assert(code.characters.count > 0)
        
        // 注意:redirect_uri必须和开发中平台中填写的一模一样
        // 1.准备请求路径
        let urlString = baseURL +  "oauth2/access_token"
        // 2.准备请求参数
        let parameters = ["client_id": MZCAppKey, "client_secret": MZCAppSecret, "grant_type": "authorization_code", "code": code, "redirect_uri": MZCRedirect]
        // 3.发送POST请求
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON { response in
                debugPrint(response)     // prints detailed description of all response properties
                
                switch response.result {
                case .Success:
                    if let t_JSON = response.result.value {
                        
                        self.loadMeInfo(t_JSON , finished : finished)
                        
                    }
                case .Failure(let error):
                    finished(tokenDic : nil , userDic : nil, error: error)
                }
        }
    }
    
    
    
    func loadMeInfo(data : AnyObject , finished : (tokenDic: AnyObject? , userDic: AnyObject?, error: NSError?) -> ()) {
    
        // 断言
        // 断定access_token一定是不等于nil的, 如果运行的时access_token等于nil, 那么程序就会崩溃, 并且报错
        
        var tokenDic = data as! [String : AnyObject]
        
        assert(tokenDic["access_token"] != nil, "使用该方法必须先授权")
        assert(tokenDic["uid"] != nil, "使用该方法必须有用户id")
        
        // 1.准备请求路径
        let urlString = baseURL + "2/users/show.json"
        // 2.准备请求参数
        let access_token = tokenDic["access_token"] as! String
        let uid = tokenDic["uid"] as! String
        
        let parameters = ["access_token": access_token, "uid": uid]
        // 3.发送GET请求
        Alamofire.request(.GET, urlString, parameters: parameters)
            .responseJSON { response in
                debugPrint(response)
                
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                switch response.result {
                case .Success:
                    if let userData = response.result.value {
                        
                        let userDic = userData as! [String : AnyObject]
                        // 获取数据核心 令牌数据 + 个人(我) 数据
                        
                        finished(tokenDic: tokenDic, userDic: userDic, error: nil)
                        
                        //登录成功发送通知更换UIWindow
                        MZCNSNotificationCenterMessage.shareInstance.post_uiWindowOfNewVersion()
                    }
                case .Failure(let error):
                    finished(tokenDic : nil , userDic : nil, error: error)
                }
                
        }
        
    }

}
