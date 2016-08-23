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
    
    //MARK:- 属性
    @IBOutlet weak var KeyBoardToolBarbottom: NSLayoutConstraint!
    
    @IBOutlet weak var emoticonTextView: MZCEmoticonTextView!
    
    @IBOutlet weak var tipCountLabel: UILabel!
    
    @IBOutlet weak var pictureHLayout: NSLayoutConstraint!
    
    @IBOutlet weak var pictureView: UIView!
    
    private lazy var customNavTextView : MZCEditMessageCustomNavTitleView = MZCEditMessageCustomNavTitleView()
    
    private lazy var keyboardEmoticonViewController : MZCKeyboardEmoticonViewController = {
        
        return MZCKeyboardEmoticonViewController {[unowned self] (emoticon) in
            self.emoticonTextView.insertEmoticon(emoticon)
            //主动调用代理方法 是否隐藏占位文字 是否隐藏发送按钮
            self.textViewDidChange(self.emoticonTextView)
        }
    }()
    
    
    
    //MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    /** 弹出键盘 */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        emoticonTextView.becomeFirstResponder()
    }
    /** 关闭键盘 */
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        emoticonTextView.resignFirstResponder()
    }
    /** 销毁 */
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK:- 工厂
    class func editMessageViewController() -> MZCEditMessageViewController {
        return NSBundle.mainBundle().loadNibNamed("MZCEditMessageViewController", owner: nil, options: nil).last as! MZCEditMessageViewController
    }
    
}

//MARK:- private
extension MZCEditMessageViewController {
    
    private func setupUI(){
        setupNavUI()
        setupNotf()
        setupKeyBoardUI()
        setupPictureViewUI()
        emoticonTextView.delegate = self
    }
    /** navigationUI */
    private func setupNavUI(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MZCEditMessageViewController.closeDidClick))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MZCEditMessageViewController.sendDidClick))
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        self.navigationItem.titleView = customNavTextView
    }
    
    /** 通知 */
    private func setupNotf(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MZCEditMessageViewController.keyboardWillChange), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupKeyBoardUI(){
        addChildViewController(keyboardEmoticonViewController)
    }
    
    private func setupTipCountLabelUI() ->Bool {
        let count = tipTote - emoticonTextView.text.characters.count
        let flg = count >= 0
        tipCountLabel.text = "\(count)"
        tipCountLabel.textColor = flg ? UIColor.grayColor() : UIColor.redColor()
        return flg
    }
    
    private func setupPictureViewUI() {
        let vc = MZCEditMessagePictureCollectionViewController()
        vc.collectionView!.frame = pictureView.bounds
        addChildViewController(vc)
        pictureView.addSubview(vc.collectionView!)
    }
}


//MARK:- event
extension MZCEditMessageViewController {
    func closeDidClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendDidClick(){
        
        let text = emoticonTextView.textViewStr()
        
        MZCAlamofire.shareInstance.sendMessage(text: text) { (error) in
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
    @IBAction func emoticonKeyBoardWillChange(sender: AnyObject) {
        /** 切换键盘需要先将键盘关闭,然后在打开 */
        emoticonTextView.resignFirstResponder()
        
        /** 判断是否是系统默认键盘 nil为默认键盘 */
        if emoticonTextView.inputView == nil {
            /** 设置键盘为自定义键盘 */
            emoticonTextView.inputView = keyboardEmoticonViewController.view
        }else{
            /** 设置键盘为系统键盘 */
            emoticonTextView.inputView = nil
        }
        /** 切换键盘需要先将键盘关闭,然后在打开 */
        emoticonTextView.becomeFirstResponder()
        
    }
    
    
    @IBAction func pictureKeyBoardWillChange(sender: AnyObject) {
        
        let flg = pictureHLayout.constant == 0
        
        pictureHLayout.constant = flg ? self.view.bounds.height * 0.65 : 0
        
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
        
        emoticonTextView.resignFirstResponder()
        
    }
    
}
private let tipTote = 5
//MARK:- Delegate
extension MZCEditMessageViewController : UITextViewDelegate {
    func textViewDidChange(textView: UITextView){
        
        let flg = setupTipCountLabelUI()
        navigationItem.rightBarButtonItem?.enabled = emoticonTextView.hasText() && flg
        emoticonTextView.placeholderLabel.hidden = emoticonTextView.hasText()
    
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        emoticonTextView.resignFirstResponder()
    }
}
