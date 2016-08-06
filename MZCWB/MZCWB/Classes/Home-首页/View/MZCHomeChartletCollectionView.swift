//
//  MZCHomeChartletCollectionView.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/1.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import YYWebImage
import QorumLogs
private let MZCPictureCell = "MZCPictureCell"
enum MZCChartletViewType : Int {
    case originalType
    case forwardType
}

class MZCHomeChartletCollectionView: UICollectionView {
    
    var chartletViewType : MZCChartletViewType?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        chartletViewType = MZCChartletViewType.originalType
        super.init(frame: frame, collectionViewLayout: MZCHomeChartViewLayout())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        chartletViewType = MZCChartletViewType.forwardType
        setupUI()
    }
    
    var mode : MZCHomeViewMode? {
        didSet {
            if mode!.isShowChartlet {
                hidden = false
                let (itemSize,contentSize) = mode!.centersSize
                
                self.contentSize = contentSize
                
                let chartViewLayout = collectionViewLayout as! MZCHomeChartViewLayout
                
                chartViewLayout.itemSize = itemSize

                if chartletViewType == MZCChartletViewType.originalType {
                    frame = mode!.originalChartletViewFrame
                }
                self.dataSource = self
                reloadData()
            }else {
                hidden = true
            }
        }
    }
    
    private func setupUI(){
        registerClass(MZCHomeChartletViewCell.self, forCellWithReuseIdentifier: MZCPictureCell)
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

    private lazy var imgView : UIImageView = {
        let view = UIImageView()
        self.addSubview(view)
        return view
    }()
    
    var url : NSURL? {
        didSet {
            imgView.image = YYWebImageManager.sharedManager().cache?.getImageForKey(url!.absoluteString)
            imgView.frame = self.bounds
            imgView.contentMode = UIViewContentMode.ScaleAspectFill
            imgView.layer.masksToBounds = true
        }
    }
    
}

// MARK: - 贴图代理
extension MZCHomeChartletCollectionView : UICollectionViewDataSource {
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let pic_urls = self.mode!.pic_urls_ViewMode else{
            return 0
        }
        
        return pic_urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MZCPictureCell, forIndexPath: indexPath) as! MZCHomeChartletViewCell
        
        guard let urls = self.mode!.pic_urls_ViewMode where urls.count > 0 else {
            return cell
        }
        let url = urls[indexPath.item]
        cell.url = url

        return cell
    }
}