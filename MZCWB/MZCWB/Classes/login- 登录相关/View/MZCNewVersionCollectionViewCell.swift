//
//  MZCNewVersionCollectionViewCell.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/26.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit

protocol MZCNewVersionDelegate : NSObjectProtocol{
    func skipClick()
    func goInClick()
}

class MZCNewVersionCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var goInButton: UIButton!
    //使用weak
    weak var delegate : MZCNewVersionDelegate?
    
    var index : Int  = 0 {
        didSet {
            
            let imgName = "new_feature_\(index + 1)"
            imgView.image = UIImage.init(named: imgName)
            
            switch index {
            case 0:
                skipButton.hidden = false
                goInButton.hidden = true
            case 3:
                goInButton.hidden = false
                skipButton.hidden = true
            default:
                skipButton.hidden = true
                goInButton.hidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
//MARK:- event
extension MZCNewVersionCollectionViewCell {
    
    @IBAction func skipClick(sender: AnyObject) {
        delegate?.skipClick()
    }

    @IBAction func goInClick(sender: AnyObject) {
        delegate?.goInClick()
    }
}
