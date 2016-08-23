//
//  MZCEditMessagePictureCollectionViewCell.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/18.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs

protocol MZCEditMessagePictureDelegate : NSObjectProtocol {
    func openPicture()
    func deletePicture(cell : MZCEditMessagePictureCollectionViewCell)
}

class MZCEditMessagePictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgBtn: UIButton!
    
    @IBOutlet weak var delBtn: UIButton!
    
    weak var delegate : MZCEditMessagePictureDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var img : UIImage?  {
        didSet {
            if img == nil {
                imgBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: .Normal)
                imgBtn.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: .Highlighted)
                delBtn.hidden = true
            }else {
                imgBtn.setBackgroundImage(img, forState: .Normal)
                imgBtn.setBackgroundImage(img, forState: .Highlighted)
                delBtn.hidden = false
            }
        }
    }
    
}

extension MZCEditMessagePictureCollectionViewCell {
    
    @IBAction func openPicture(sender: AnyObject) {
        delegate?.openPicture()
    }
    
    @IBAction func deletePicture(sender: AnyObject) {
        delegate?.deletePicture(self)
    }
    
}