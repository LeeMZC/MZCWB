//
//  MZCTokenLoginWebViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/24.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
import SVProgressHUD
import Alamofire
import SwiftyJSON
class MZCTokenLoginWebViewController: UIViewController {
    
    //MARK:- 属性
    private var accountTokenMode : MZCAccountTokenMode?
    
    private lazy var leftButton : UIBarButtonItem = {
        return UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Done, target: self, action: #selector(MZCTokenLoginWebViewController.leftDidClick))
        
    }()
    
    private lazy var rightButton : UIBarButtonItem = {
        return UIBarButtonItem(title: "填充", style: UIBarButtonItemStyle.Done, target: self, action: #selector(MZCTokenLoginWebViewController.rightDidClick))
        
    }()
    
    private lazy var loginWebView : UIWebView? = {
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(MZCAppKey)&redirect_uri=\(MZCRedirect)"
        // 2.创建URL
        guard let url = NSURL(string: urlStr) else
        {
            return nil
        }
        // 3.创建Request
        let request = NSURLRequest(URL: url)
        
        // 4.加载登录界面
        let size = UIScreen.mainScreen().bounds.size
        let webView = UIWebView(frame: CGRectMake(0, 0, size.width, size.height))
        
        webView.loadRequest(request)
        
        webView.delegate = self
        
        return webView
        
    }()
    
    //MARK:- UI生命周期
    override func viewDidLoad() {
        QL1("")
        super.viewDidLoad()
        
        
        setupNavUI()
        
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        setupWebViewUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- 自定义函数
    private func setupWebViewUI(){
        
        guard let t_loginWebView = loginWebView else {
            return
        }
        
        self.view.addSubview(t_loginWebView)
    }
    
    private func setupNavUI(){
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    

}
//MARK:- event
extension MZCTokenLoginWebViewController {
    @objc private func leftDidClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func rightDidClick(){
        
    }
}
//MARK:- Delegate
extension MZCTokenLoginWebViewController : UIWebViewDelegate {
    //MARK:拦截请求
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        
        
        guard let t_urlString = request.URL?.absoluteString else{
            return false
        }
        
        if !t_urlString.hasPrefix(MZCRedirect) {
            return true
        }
        
        guard let t_query = request.URL?.query else{
        
            return false
        }
        
        //MARK: 参数code开头 关闭webView 开启网络请求
        if t_query.hasPrefix("code"){
            
            let val = t_query.substringFromIndex("code=".endIndex)
            QL1(val)
            MZCAlamofire.shareInstance.AccountToKen(val, finished: { (tokenDic, userDic, error) in
                
                guard let t_tokenDic = tokenDic else{
                    return
                }
                
                guard let t_userDic = userDic else{
                    return
                }
                
                self.accountTokenMode = MZCAccountTokenMode(dict: t_tokenDic as! [String : AnyObject])
                let userMode = MZCUserMode(dict: t_userDic as! [String : AnyObject])
                self.accountTokenMode!.user = userMode
                
                // 序列号令牌
                self.accountTokenMode?.saveAccountToKen()
                
                SVProgressHUD.dismiss()
                
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            
            return false
        }
        
        return false
    }
    
    func webViewDidStartLoad(webView: UIWebView){
        SVProgressHUD.showWithStatus("正在加载中...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
    }
    func webViewDidFinishLoad(webView: UIWebView){
        SVProgressHUD.dismiss()
        

    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
    
    }
}
