//
//  HomeViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/10/08.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    struct TestUser {
        var id = 1
        var userName = "Sekaryo Shin"
        var nickName = "ゆるふわ草食系男子"
        var live = "Okinawa"
        var keywords = ["guitar", "programing", "coffeescript"]
    }
    
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
    
    var images           = NSMutableArray()
    var contentsOfScroll = NSMutableArray()
    
    // ボタンアニメーション用のフラグ
    var animated = false
    
    /**
    *  viewDidLoad
    *  画面が描画される際に1度だけ実行される、各種変数などの初期化処理に
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.delegate = self

        for (var i = 0; i < self.testImagesName.count; i++){
            var image = UIImage()
            image = UIImage(named: self.testImagesName[i])!
            
            self.images.addObject(image)
        }
 
        maxDisplayViewNum = self.images.count
        
        leftViewIndex  = 0
        rightViewIndex = maxDisplayViewNum - 1
        
        self.updateScrollViewSetting()
    }
    
    /**
    *  viewWillAppear
    *  画面が描画される度に実行される、各種変数などの初期化処理に
    */
    override func viewWillAppear(animated: Bool) {
        self.animated = false
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
            var image = self.images[i] as UIImage
            
            var btn = UIButton()
            btn.frame = CGRectMake(imageWidth * CGFloat(i), 20, imageWidth, imageHeight)
            btn.tag = i
            
            btn.setImage(image, forState: .Normal)
            btn.addTarget(self, action: "selectedButton:", forControlEvents: .TouchUpInside)
            
            self.contentsOfScroll.addObject(btn)
            
            self.scrollView.addSubview(btn)
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
    * スクロールが起きる際に呼び出されるイベント
    *
    * param: scrollView スクロールビュー
    */
    func scrollViewDidScroll(scrollView:UIScrollView) {
        var currentIndex :NSInteger = NSInteger(scrollView.contentOffset.x / imageWidth)
        var indexMovement:NSInteger = currentIndex - leftImageIndex
        
       	for (var i = 0; i < abs(indexMovement); i++) {
            if (indexMovement > 0){
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
        var direction  :NSInteger = 0
        var viewIndex  :NSInteger = 0
        
        if (scrollDirection == ScrollDirection.kScrollDirectionLeft){
            direction  = -1
            viewIndex  = rightViewIndex
        }
        else if (scrollDirection == ScrollDirection.kScrollDirectionRight){
            direction  = 1
            viewIndex  = leftViewIndex
        }
        
        var btn = self.contentsOfScroll[viewIndex] as UIButton
        btn.frame.origin.x += imageWidth * CGFloat(self.images.count * direction)
        
        // 画面に映る最も左のインデックスを更新
        leftImageIndex += direction
        
        // 画面外の両端の画像のインデックスを更新
        leftViewIndex  = self.addImageIndex(leftViewIndex , incremental: direction)
        rightViewIndex = self.addImageIndex(rightViewIndex, incremental: direction)
    }
    
    /**
    * selectedButton
    * ボタンをタップした際に呼び出されるイベント
    *
    * param: btn タップされたボタンオブジェクト
    */
    func selectedButton(btn: UIButton!) {
        
        if (animated){
            return
        }
        
        animated = true
        
        var animation = CABasicAnimation(keyPath:"position")
        animation.duration    = 0.1
        animation.repeatCount = 3
        animation.fromValue = NSValue(CGPoint:btn.layer.position)
        animation.toValue   = NSValue(CGPoint:CGPointMake(btn.layer.position.x, btn.layer.position.y - CGFloat(40)))
        animation.autoreverses = true
        
        btn.layer.addAnimation(animation, forKey: "move-layer")
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("transitionProfilePage")
                                                  , userInfo: nil, repeats: false)
    }
    
    /**
    * transitionProfilePage
    * Profileページへと遷移するセグエを呼び出す
    */
    func transitionProfilePage() {
        self.performSegueWithIdentifier("ProfileForSegue", sender: self)
    }
    
    /**
    * prepareForSegue
    * 次のページへの値渡しを行う
    *
    * param: segue
    * param: sender
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier != "ProfileForSegue"){
           return
        }
        
        var testUser = TestUser()
       
        var vc = segue.destinationViewController as ProfileViewController
        vc.id = testUser.id
        vc.userName = testUser.userName
        vc.nickName = testUser.nickName
        vc.live     = testUser.live
        vc.keywards = testUser.keywords
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