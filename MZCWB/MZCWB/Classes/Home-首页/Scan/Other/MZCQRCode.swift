//
//  MZCQRCode.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/7/24.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import AVFoundation
class MZCQRCode: NSObject {
    
    //MARK:- 二维码扫描
    // 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    // 输出对象
    lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    // 预览图层
    lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    /// 输入对象
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: device)
    }()
    
    override init() {
        super.init()
        self.scanQRCode()
    }
    
    private func scanQRCode()
    {
        // 1.判断输入能否添加到会话中
        if !session.canAddInput(input)
        {
            return
        }
        // 2.判断输出能够添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        // 3.添加输入和输出到会话中
        session.addInput(input)
        session.addOutput(output)
        
        // 4.设置输出能够解析的数据类型
        // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
        output.metadataObjectTypes = output.availableMetadataObjectTypes
    
        
    }
    
    func startRunning() {
        // 7.开始扫描
        session.startRunning()
    }
    
    deinit{
        print("deinit")
    }
    
}
