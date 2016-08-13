//
//  MZCEditMessageViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/14.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
class MZCEditMessageViewController: UIViewController {
    
    //MARK:- IB属性
    @IBOutlet weak var KeyBoardToolBarbottom: NSLayoutConstraint!
    @IBOutlet weak var customContentTextView: MZCEditMessageCustomContentTextView!
    
    
    
    //MARK:- 工厂
    class func editMessageViewController() -> MZCEditMessageViewController {
        return NSBundle.mainBundle().loadNibNamed("MZCEditMessageViewController", owner: nil, options: nil).last as! MZCEditMessageViewController
    }
    
    //MARK:- lazy
    private lazy var customNavTextView : MZCEditMessageCustomNavTitleView = {
        let view = MZCEditMessageCustomNavTitleView()
        return view
    }()
    
    private lazy var keyboardEmoticonViewController : MZCKeyboardEmoticonViewController = {
        return MZCKeyboardEmoticonViewController()
    }()
    
    //MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    /** 弹出键盘 */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        customContentTextView.becomeFirstResponder()
    }
    /** 关闭键盘 */
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        customContentTextView.resignFirstResponder()
    }
    /** 销毁 */
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

//MARK:- private
extension MZCEditMessageViewController {
    
    private func setupUI(){
        setupNavUI()
        setupNotf()
        setupKeyBoardUI()
        customContentTextView.delegate = self
    }
    /** navigationUI */
    private func setupNavUI(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MZCEditMessageViewController.closeDidClick))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MZCEditMessageViewController.sendDidClick))
        
        self.navigationItem.titleView = customNavTextView
    }
    
    /** 通知 */
    private func setupNotf(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MZCEditMessageViewController.keyboardWillChange), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupKeyBoardUI(){
        addChildViewController(keyboardEmoticonViewController)
    }
}


//MARK:- event
extension MZCEditMessageViewController {
    func closeDidClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendDidClick(){
        MZCAlamofire.shareInstance.sendMessage(text: customContentTextView.text) { (error) in
            
            if error == nil {
                MZCProgressHUD.showSuccessWithStatus("发送成功")
            }else{
                MZCProgressHUD.showErrorWithStatus("发送失败")
            }
        }
    }
    
    @objc private func keyboardWillChange(note: NSNotification){
        let endRect = note.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let endDuration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        
        KeyBoardToolBarbottom.constant = MZCScreenSize.height - endRect.origin.y
        let curve = note.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        UIView.animateWithDuration(endDuration) {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.integerValue)!)
            self.view.layoutIfNeeded()
        }
        
    }
    
    /** 切换键盘 */
    @IBAction func keyBoardWillChange(sender: AnyObject) {
        /** 切换键盘需要先将键盘关闭,然后在打开 */
        customContentTextView.resignFirstResponder()
        
        /** 判断是否是系统默认键盘 nil为默认键盘 */
        if customContentTextView.inputView == nil {
            /** 设置键盘为自定义键盘 */
            customContentTextView.inputView = keyboardEmoticonViewController.view
        }else{
            /** 设置键盘为系统键盘 */
            customContentTextView.inputView = nil
        }
        /** 切换键盘需要先将键盘关闭,然后在打开 */
        customContentTextView.becomeFirstResponder()
    }
    
}

//MARK:- Delegate
extension MZCEditMessageViewController : UITextViewDelegate {
    func textViewDidChange(textView: UITextView){
        self.navigationItem.rightBarButtonItem?.enabled = customContentTextView.hasText()
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        customContentTextView.resignFirstResponder()
    }
}
