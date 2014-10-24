//
//  ViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/10/08.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let testImagesName = [
            "foto_tomari_s.png"
            , "foto_angie_s.png"
            , "foto_sekaryo_s.png"
            , "foto_ogata_s.png"
            , "foto_kikuchi_s.png"
        ]
    
    // 左に移動したか右に移動したかを判別するためのステータス
    enum ScrollDirection {
        case kScrollDirectionLeft
        case kScrollDirectionRight
    }
    
    // 画像の表示数
    var displayViewNum    = 0
    var maxDisplayViewNum = 0
    
    // 画像のサイズ
    let imageWidth :CGFloat	= 210
    let imageHeight:CGFloat = 105
    
    // スクロール数の限界値（擬似的に無限スクロールしているように見せかけている）
    let maxScrollableImages = 10000
    
    // 画面に映る最も左端の画像のインデックス
    var leftImageIndex:NSInteger = 0
    
    // 画面外に待機している両端の画像のインデックス
    var leftViewIndex :NSInteger = 0
    var rightViewIndex:NSInteger = 0
    
    var images = NSMutableArray()
    
    /**
    *  viewDidLoad
    *  画面が描画される際に1度だけ実行される、各種変数などの初期化処理に仕様
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.delegate = self

        for (var i = 0; i < self.testImagesName.count; i++){
            var iv = UIImageView()
            iv.image = UIImage(named: self.testImagesName[i])
            iv.tag = i
            
            self.images.addObject(iv)
            
            self.scrollView.addSubview(iv)
        }
 
        maxDisplayViewNum = self.images.count
        displayViewNum = maxDisplayViewNum - 2
        
        leftViewIndex  = 0
        rightViewIndex = maxDisplayViewNum - 1
        
        self.updateScrollViewSetting()
    }
    
    /**
    * updateScrollViewSetting
    * スクロールバーに関する初期化処理
    */
    func updateScrollViewSetting() {
        // スクロールバーのサイズを設定
        var contentSize = CGSizeMake(0, imageHeight)
        contentSize.width = imageWidth * CGFloat(self.images.count * maxScrollableImages)
        
        // スクロールバーの中央から画像を表示するよう調整
        var contentOffSet = CGPointZero
        contentOffSet.x = CGFloat(maxScrollableImages) * imageWidth
        
        // 画面の最も左に表示されている画像のインデックス
        leftImageIndex = 0
        
        // 画像の初期位置の設定
        for (var i = 0; i < self.images.count; i++){
            var iv = self.images[i] as UIImageView
            iv.frame = CGRectMake(imageWidth * CGFloat(i), 0, imageWidth, imageHeight)
            
            self.images[i] = iv
        }
        
        // UIScrollViewの可視領域の左端
        leftImageIndex = 0
        
        // ScrollViewへの初期設定
        self.scrollView.contentOffset = contentOffSet
        self.scrollView.contentSize   = contentSize
        self.scrollView.showsHorizontalScrollIndicator = false
    }
    
    /**
    * scrollViewDidScroll
    * スクロールが怒った際に、呼び出されるイベント
    * param: scrollView スクロールビュー
    */
    func scrollViewDidScroll(scrollView:UIScrollView) {
        var pos   :CGFloat   = scrollView.contentOffset.x / imageWidth
        var delta :CGFloat   = pos - CGFloat(leftImageIndex)
        var pageCount :NSInteger = NSInteger(fabs(delta))
        
       	for (var i = 0; i < pageCount; i++) {
            if (delta > 0){
                self.scrollWithDirection(ScrollDirection.kScrollDirectionRight)
            }
            else {
                self.scrollWithDirection(ScrollDirection.kScrollDirectionLeft)
            }
        }
    }
    
    /**
    * addImageIndex
    * リングバッファの添字を計算する
    *
    * param: index       画面から溢れ出ている画像の番号（左端と右端）
    * param: incremental スクロールした行番号
    * returns: リングバッファの添字
    */
    func addImageIndex(index:NSInteger, incremental:NSInteger) -> NSInteger {
        return (index + incremental + maxDisplayViewNum) % maxDisplayViewNum
    }

    /**
    * scrollWithDirection
    * 画像の位置を更新する
    *
    * param: scrollDirection 左に移動したのか、右に移動したのかを示すステータス変数
    */
    func scrollWithDirection(scrollDirection:ScrollDirection) {
        var sign       :NSInteger = 0
        var viewIndex  :NSInteger = 0
        var imageIndex :NSInteger = 0
        
        if (scrollDirection == ScrollDirection.kScrollDirectionLeft){
            sign = -1
            viewIndex  = rightViewIndex
            imageIndex = leftImageIndex - 1
        }
        else if (scrollDirection == ScrollDirection.kScrollDirectionRight){
            sign = 1
            viewIndex  = leftViewIndex
            imageIndex = leftImageIndex + displayViewNum
        }
        
        var iv = self.images[viewIndex] as UIImageView
        iv.frame.origin.x += imageWidth * CGFloat(self.images.count * sign)
        
        leftImageIndex += sign
        
        leftViewIndex  = self.addImageIndex(leftViewIndex , incremental: sign)
        rightViewIndex = self.addImageIndex(rightViewIndex, incremental: sign)
    }
    
    /**
    * didReciveMemoryWarning
    * メモリが圧迫されると警告を示す
    */
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
        super.didReceiveMemoryWarning()
    }
}