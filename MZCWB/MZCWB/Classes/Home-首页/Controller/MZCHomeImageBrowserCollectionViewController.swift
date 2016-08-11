//
//  MZCHomeImageBrowserCollectionViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/8.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs

private let ImageBrowserCellIdentifier = "ImageBrowserCellIdentifier"

class MZCHomeImageBrowserViewController: UIViewController {

    /// 所有配图
    var bmiddle_pic: [NSURL]
    /// 当前点击的索引
    var indexPath: NSIndexPath
    
    init(bmiddle_pic: [NSURL], indexPath: NSIndexPath)
    {
        self.bmiddle_pic = bmiddle_pic
        self.indexPath = indexPath
        
        // 注意: 自定义构造方法时候不一定是调用super.init(), 需要调用当前类设计构造方法(designated)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: MZCHomeImageBrowserFlowLayout())
        collectionView.dataSource = self
        
        collectionView.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(collectionView)
        
        collectionView.registerNib(UINib(nibName: "MZCHomeImageBrowserCell", bundle: nil), forCellWithReuseIdentifier: ImageBrowserCellIdentifier)
        return collectionView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
}

//MARK:- delegate
extension MZCHomeImageBrowserViewController : MZCHomeImageBrowserCellDelegate , UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bmiddle_pic.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageBrowserCellIdentifier, forIndexPath: indexPath) as! MZCHomeImageBrowserCell
        
        // Configure the cell
        //        cell.backgroundColor = MZCRandomColor
        cell.delegate = self
        cell.url = bmiddle_pic[indexPath.item]
        return cell
    }

    func closeClick() {
        QL1("")
        dismissViewControllerAnimated(true, completion: nil)
    }
}

class MZCHomeImageBrowserFlowLayout: UICollectionViewFlowLayout
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
//        scrollDirection = UICollectionViewScrollDirection.Vertical
        // 4.设置分页
        collectionView?.pagingEnabled = true
        // 5.禁用回弹
        collectionView?.bounces = false
        // 6.取出滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
