//
//  MZCEditMessagePictureCollectionViewController.swift
//  MZCWB
//
//  Created by 马纵驰 on 16/8/18.
//  Copyright © 2016年 马纵驰. All rights reserved.
//

import UIKit
import QorumLogs
private let EditMessagePictureCell = "EditMessagePictureCell"

class MZCEditMessagePictureCollectionViewController: UICollectionViewController {

    var images : [UIImage] = []
    
    override func loadView() {
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: MZCEditMessagePictureFlowLayout())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

//MARK:- private
extension MZCEditMessagePictureCollectionViewController {
    private func setupUI(){
        // 注册cell
        collectionView!.registerNib(UINib(nibName: "MZCEditMessagePictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EditMessagePictureCell)
    }
    
    // 压缩图片
    private func drawImage(image : UIImage, width : CGFloat) -> UIImage {
        // 0.获取图片的size
        let height = (image.size.height / image.size.width) * width
        let size = CGSize(width: width, height: height)
        
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(size)
        
        // 2.将图片画到上下文
        image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // 3.从上下文中获取新的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4.关闭上下文
        UIGraphicsEndImageContext()
        
        // 5.返回新的图片
        return newImage
    }
}

//MARK:- delegate
extension MZCEditMessagePictureCollectionViewController : MZCEditMessagePictureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> MZCEditMessagePictureCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EditMessagePictureCell, forIndexPath: indexPath) as! MZCEditMessagePictureCollectionViewCell
        
        if images.count == indexPath.item {
            cell.img = nil
        }else {
            cell.img = images[indexPath.item]
        }
        
        cell.delegate = self
        return cell
    }
    
    func openPicture() {
        
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) else {
            print("照片源不可用")
            return
        }
        
        // 2.创建照片选择控制器
        let ipc = UIImagePickerController()
        
        // 3.设置照片源
        ipc.sourceType = .PhotoLibrary
        
        // 4.设置代理
        ipc.delegate = self
        
        // 5.弹出照片选择控制器
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    func deletePicture(cell: MZCEditMessagePictureCollectionViewCell) {
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 1.获取选择的照片
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        // 2.退出控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        // 3.用collectionView显示照片
        // 3.0.压缩照片
        let newImage = drawImage(image, width: 450)
        
        // 3.1.将照片存放到数组中
        images.append(newImage)
        
        // 3.2.刷新表格
        collectionView?.reloadData()
    }

}

private let MZCPictureCol : CGFloat = 3
class MZCEditMessagePictureFlowLayout: UICollectionViewFlowLayout
{
    // 准备布局
    override func prepareLayout() {
        // 1.设置每个cell的尺寸
        let wh =  (MZCScreenSize.width - MZCMargin * (MZCPictureCol + 1)) / MZCPictureCol
        itemSize = CGSizeMake(wh, wh)
        
        // 2.设置cell之间的间隙
        minimumInteritemSpacing = MZCMargin
        minimumLineSpacing = MZCMargin
        //设置CollectionView内边距
        sectionInset = UIEdgeInsetsMake(MZCMargin, MZCMargin, 0, MZCMargin)
        
        // 3.设置滚动方向
//        scrollDirection = UICollectionViewScrollDirection.Horizontal
        scrollDirection = UICollectionViewScrollDirection.Vertical
        // 5.禁用回弹
        collectionView?.bounces = false
        // 6.取出滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
    }
}

