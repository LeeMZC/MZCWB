//
//  MZCKeyboardEmoticonCell.swift
//  MZCCustomKeyboard
//
//  Created by 马纵驰 on 16/8/12.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
class MZCKeyboardEmoticonCell: UICollectionViewCell {

    @IBOutlet weak var emoticonBtn: UIButton!
    
    var mode : MZCEmoticonMode? {
        didSet {
            
            guard let t_mode = mode else {
                fatalError("mode == nil")
            }
            
            emoticonBtn.setImage(nil, forState: UIControlState.Normal)
            emoticonBtn.setTitle("", forState: UIControlState.Normal)
            
            let name = t_mode.sourceName
            
            switch t_mode.emoticonType! {
            case MZCEmoticonType.Emoji:
                emoticonBtn.setTitle(name, forState: UIControlState.Normal)
            case MZCEmoticonType.Img:
                emoticonBtn.setImage(UIImage(named: name), forState: UIControlState.Normal)
            case MZCEmoticonType.Delete:
                emoticonBtn.setImage(UIImage(named: name), forState: UIControlState.Normal)
                emoticonBtn.setImage(UIImage(named: name + "_highlighted"), forState: UIControlState.Highlighted)
                
            default:
                break
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}

