//
//  MZCNewVersionCollectionViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/26.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
private let reuseIdentifier = "NewVersionCell"

class MZCNewVersionCollectionViewController: UICollectionViewController {
    
    //MARK:- 属性
    var imgIndex = 1
    
    var itemCount = 4
    //MARK:- UICollectionViewController 函数
    
    override func loadView() {
        collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: MZCNewVersionLayout())
    }
    
    override func viewDidLoad() {
        QL1("")
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- private
    private func setupUI(){
        
        collectionView!.registerNib(UINib(nibName: "MZCNewVersionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
}

extension MZCNewVersionCollectionViewController {
    //MARK:- UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> MZCNewVersionCollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MZCNewVersionCollectionViewCell
        
        cell.delegate = self
        
        cell.index = indexPath.item
        
        return cell
    }
    
    //MARK:- UICollectionViewDelegate
    //当cell完全展示完毕时调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        
        
        
        let path = collectionView.indexPathsForVisibleItems().last!
        
        let cell = collectionView.cellForItemAtIndexPath(path) as! MZCNewVersionCollectionViewCell
        
        if (path.item == itemCount - 1){
            cell.goInButton.vibrationAni()
        }
    }
}

//MARK:- 自定义布局
class MZCNewVersionLayout: UICollectionViewFlowLayout
{
    // 准备布局
    override func prepareLayout() {
        // 1.设置每个cell的尺寸
        itemSize = UIScreen.mainScreen().bounds.size
        // 2.设置cell之间的间隙
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // 3.设置滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 4.设置分页
        collectionView?.pagingEnabled = true
        // 5.禁用回弹
        collectionView?.bounces = false
        // 6.取出滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}

//代理
extension MZCNewVersionCollectionViewController : MZCNewVersionDelegate {
    
    func skipClick() {
        QL1("")
        let indexPath = NSIndexPath(forItem: itemCount - 1, inSection: 0)
        collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
    }
    
    func goInClick() {
        QL1("")
        MZCNSNotificationCenterMessage.shareInstance.post_welcomeViewControllerWillChange()
    }
}


