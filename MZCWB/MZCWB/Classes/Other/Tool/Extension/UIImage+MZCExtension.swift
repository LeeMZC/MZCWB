//
//  UIImage+MZCExtension.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/9.
//  Copyright © 2016年 马纵驰. All rights reserved.
//


import UIKit

extension UIImage {
    
    func mzc_fixedWidthScalingSize() ->CGSize {
        let width = MZCScreenSize.width
        let height = width * self.size.height / self.size.width
        return CGSizeMake(width, height)
    }
}