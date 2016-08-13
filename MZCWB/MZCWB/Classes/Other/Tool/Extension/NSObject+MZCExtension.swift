//
//  NSObject+MZCExtension.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/25.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
var signalSource: dispatch_source_t!
var signalOnceToken = dispatch_once_t()

extension NSObject{
    func runtimerDuBug(debug : ()->()){
        
        dispatch_once(&signalOnceToken) {
            let queue = dispatch_get_main_queue()
            signalSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL,
                                                  UInt(SIGSTOP), 0, queue)
            if let source = signalSource {
                dispatch_source_set_event_handler(source) {
                    debug()
                }
                dispatch_resume(source)
            }
        }
    }
}