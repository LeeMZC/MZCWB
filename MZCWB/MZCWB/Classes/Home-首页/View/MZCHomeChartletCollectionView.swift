//
//  MZCHomeChartletCollectionView.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/1.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import YYWebImage
class MZCHomeChartletCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: MZCHomeChartViewLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:- 根据mode设置贴图UI 在cell的set方法中
    func chartletSetupUI(mode : MZCHomeViewMode , isOriginal : Bool){
        if mode.isShowChartlet {
            hidden = false
            let (itemSize,contentSize) = mode.centersSize
            if isOriginal {frame = mode.originalChartletViewFrame }
            self.contentSize = contentSize
            
            let chartViewLayout = collectionViewLayout as! MZCHomeChartViewLayout
            
            chartViewLayout.itemSize = itemSize
            reloadData()
        }else {
            hidden = true
        }
    }
}

// MARK: - 贴图自定义布局
class MZCHomeChartViewLayout: UICollectionViewFlowLayout
{
    // 准备布局
    override func prepareLayout() {
        
        super.prepareLayout()
        // 1.设置每个cell的尺寸
        // 2.设置cell之间的间隙
        minimumInteritemSpacing = 1.0
        minimumLineSpacing = 1.0
        // 5.禁用回弹
        collectionView?.bounces = false
        // 6.取出滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
// MARK: - 贴图cell
class MZCHomeChartletViewCell : UICollectionViewCell{
    
    let imgView = UIImageView()
    
    var url : NSURL? {
        didSet {
            imgView.image = YYWebImageManager.sharedManager().cache?.getImageForKey(url!.absoluteString)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        imgView.frame = self.bounds
        imgView.contentMode = UIViewContentMode.ScaleAspectFill
        imgView.layer.masksToBounds = true
        addSubview(imgView)
    }
    
}