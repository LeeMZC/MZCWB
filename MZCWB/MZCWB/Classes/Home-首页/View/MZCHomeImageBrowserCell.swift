//
//  MZCHomeImageBrowserCell.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/8.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
import YYKit

protocol MZCHomeImageBrowserCellDelegate : NSObjectProtocol {
    func closeClick()
}

class MZCHomeImageBrowserCell: UICollectionViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
    }
    
    private lazy var imgView : UIImageView = {
        let imgView = UIImageView()
        self.scrollView.addSubview(imgView)
        return imgView
    }()
    
    weak var delegate : MZCHomeImageBrowserCellDelegate?
    
    var url : NSURL? {
        didSet {
            
            guard let t_url = url else{
                return
            }
            
            recoveryFrame()
            
            imgView.setImageWithURL(t_url, placeholder: nil, options: YYWebImageOptions.SetImageWithFadeAnimation) { (img, url, type, stage, error) in
                if stage == YYWebImageStage.Finished {
                    
                    if img?.size.height > MZCScreenSize.height {
                        let size = img!.mzc_fixedWidthScalingSize()
                        self.imgView.frame = CGRectMake(0, 0, size.width, size.height)
                        self.scrollView.contentSize = size
                        
                    }else{
                        self.imgView.center = CGPointMake(MZCScreenSize.width / 2, MZCScreenSize.height / 2)
                        self.imgView.bounds.size = img!.mzc_fixedWidthScalingSize()
                    }
                
                }
            }
        }
    }
    
    private func recoveryFrame(){
        
        scrollView.contentSize = CGSizeZero
        
        imgView.transform = CGAffineTransformIdentity
    }
    
}
//MARK:- 事件
extension MZCHomeImageBrowserCell {
    
    @IBAction func closeClick(sender: AnyObject) {
        QL1("")
        delegate?.closeClick()
        
    }
    @IBAction func saveClick(sender: AnyObject) {
        
    }
    
}

//MARK:- 代理
extension MZCHomeImageBrowserCell {
    
    /**
     每一次缩放都会调用
     
     - parameter scrollView:
     */
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
    }
    /**
     缩放结束时调用
     
     - parameter scrollView:
     - parameter view:
     - parameter scale:
     */
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat){
        imgView.center = CGPointMake(MZCScreenSize.width / 2, MZCScreenSize.height / 2)
    }
    /**
     缩放即将开始时调用
     
     - parameter scrollView:
     - parameter view:
     */
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?){
        
    }
    /**
     设置需要被缩放的子控件
     
     - parameter scrollView:
     
     - returns:
     */
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imgView
    }
    
}


