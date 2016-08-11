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
    
    override func awakeFromNib() {
        chartletViewType = MZCChartletViewType.forwardType
        super.awakeFromNib()
        autoresizingMask = UIViewAutoresizing.None
        setupUI()
    }
    
    var mode : MZCHomeViewMode? {
        didSet {
            if mode!.isShowChartlet {
                self.hidden = false
                
                let chartViewLayout = collectionViewLayout as! MZCHomeChartViewLayout
                
                if self.centersSize.itemSize == CGSizeZero {
                    return
                }
                
                chartViewLayout.itemSize = self.centersSize.itemSize
                
                
                
                self.dataSource = self
                self.delegate = self
                
                reloadData()
            }else{
                self.hidden = true
            }
            
        }
    }
    
    /// 贴图视图大小
    var centersSize : (itemSize : CGSize, contentSize : CGSize)  {
        
        let count = self.mode!.pic_urls_ViewMode!.count ?? 0
        /*
         没有配图: cell = zero, collectionview = zero
         一张配图: cell = image.size, collectionview = image.size
         四张配图: cell = {90, 90}, collectionview = {2*w+m, 2*h+m}
         其他张配图: cell = {90, 90}, collectionview =
         */
        var itemSize : CGSize!
        var contentSize : CGSize!
        
        if count == 1 {
            
            let urlStr = self.mode!.pic_urls_ViewMode?.first?.absoluteString
            let img = YYWebImageManager.sharedManager().cache?.getImageForKey(urlStr!)
            guard let t_img = img else{
                return (CGSizeZero,CGSizeZero)
            }
            itemSize = t_img.size
            contentSize = t_img.size
            return (itemSize,contentSize)
        }
        
        if count == 4{
            itemSize = CGSizeMake(MZCTopicBoxWH, MZCTopicBoxWH)
            let contentW = itemSize.width * 2 + MZCMinMargin
            let contentH = itemSize.height * 2 + MZCMinMargin
            contentSize = CGSizeMake(contentW, contentH)
            return (itemSize,contentSize)
        }
        
        let col : Int = 3
        let row : Int = (count - 1) / col + 1
        itemSize = CGSizeMake(MZCTopicBoxWH, MZCTopicBoxWH)
        let contentW = CGFloat(col) * itemSize.width + (CGFloat(col) - 1) * MZCMinMargin
        let contentH = CGFloat(row) * itemSize.height + (CGFloat(row) - 1) * MZCMinMargin
        contentSize = CGSizeMake(contentW, contentH)
        
        
        return (itemSize,contentSize)
        
        
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
        minimumInteritemSpacing = MZCMinMargin
        minimumLineSpacing = MZCMinMargin
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
        let view = YYAnimatedImageView()
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
extension MZCHomeChartletCollectionView : UICollectionViewDataSource , UICollectionViewDelegate{
    
    
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        QL1("")
        
        let url = (mode?.pic_urls_middle_ViewMode[indexPath.item])!
        
        YYWebImageManager.sharedManager().requestImageWithURL(url, options: YYWebImageOptions.ShowNetworkActivity, progress: nil, transform: nil) { (_, _, _, stage, _) in
            if stage == YYWebImageStage.Finished {
                NSNotificationCenter.defaultCenter().postNotificationName(MZCPictureWillShow, object: self, userInfo: ["bmiddle_pic": (self.mode?.pic_urls_middle_ViewMode)!, "indexPath": indexPath])
            }
        }
    
    }
}

extension MZCHomeChartletCollectionView : MZCHomePopImageBrowserDataSource {
    
    func imageBrowserData() -> UIImage? {
        let selectedIndexPath : NSIndexPath = indexPathsForSelectedItems()!.first!
        
        let url = mode!.pic_urls_ViewMode![selectedIndexPath.item]
        
        guard let img = YYWebImageManager.sharedManager().cache?.getImageForKey(url.absoluteString) else {
            fatalError("img不存在")
        }
        
        return img
    }
}