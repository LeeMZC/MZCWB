//
//  MZCKeyboardEmoticonViewController.swift
//  MZCCustomKeyboard
//
//  Created by 马纵驰 on 16/8/12.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
private let MZCEmoticonCellIdentifier = "MZCKeyboardEmoticonCell"

class MZCKeyboardEmoticonViewController: UIViewController {

    @IBOutlet weak var emoticonToolBar: UIToolbar!
    //MARK:- 属性
    @IBOutlet weak var emoticoncollectionView: UICollectionView!
    
    private lazy var modes : [MZCEmoticonGroup] = MZCEmoticonGroup.loadData()
    
    //MARK:- lazy
    
    //MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- private
extension MZCKeyboardEmoticonViewController {
    private func setupUI(){
        let nib = UINib(nibName: "MZCKeyboardEmoticonCell", bundle: nil)
        emoticoncollectionView.registerNib(nib, forCellWithReuseIdentifier: MZCEmoticonCellIdentifier)
        
    }
}
//MARK:- delegate
extension MZCKeyboardEmoticonViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        assert(modes[section].groupModes != nil)
        return modes[section].groupModes!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> MZCKeyboardEmoticonCell{
        assert(modes[indexPath.section].groupModes != nil)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MZCEmoticonCellIdentifier, forIndexPath: indexPath) as! MZCKeyboardEmoticonCell
        let mode = modes[indexPath.section].groupModes![indexPath.item]
        cell.mode = mode
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return modes.count
    }
    
    //MARK: 点击表情保存到最近表情组中
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let mode = modes[indexPath.section].groupModes![indexPath.item]
        if mode.cellType == MZCEmoticonCellType.Delete { return }
        
        mode.clickCount += 1
        modes[0].appendFavoriteEmoticon(mode: mode)
        
    }
    
}
//MARK:- event
extension MZCKeyboardEmoticonViewController {
    
    @IBAction func selectedEmoticonType(sender: UIBarButtonItem) {
        let indexPath = NSIndexPath(forItem: 0, inSection: sender.tag)
        emoticoncollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        
    }
    
}
//MARK:- FlowLayout
class MZCKeyboardEmoticonLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        // 1.计算cell宽度
        let width = UIScreen.mainScreen().bounds.width / 7
        let height = collectionView!.bounds.height / 3
        itemSize = CGSize(width: width, height: height)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 2.设置collectionView
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}