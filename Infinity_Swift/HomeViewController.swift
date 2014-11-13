//
//  HomeViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/10/08.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit
import AssetsLibrary

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // 次のページへ渡すユーザ情報
    var selectedUserId = NSString()
    var userIds        = NSMutableArray()
    
    let imageWidth :CGFloat	= 210
    let imageHeight:CGFloat = 105
    var images           = NSMutableArray()
    var contentsOfScroll = NSMutableArray()
 
    // 画像の表示数
    var maxDisplayViewNum = 0
   
    // スクロール数の限界値（この繰り返し回数の中で擬似的に無限スクロールしているように見せかけている）
    let maxScrollableImages = 10000
    
    // 画面に映る最も左端の画像のインデックス
    var leftImageIndex:NSInteger = 0
    
    // 左に移動したか右に移動したかを判別するためのステータス
    enum ScrollDirection {
        case kScrollDirectionLeft
        case kScrollDirectionRight
    }
    
    // 画面外に待機している両端の画像のインデックス
    var leftViewIndex :NSInteger = 0
    var rightViewIndex:NSInteger = 0
   
    // ボタンアニメーション用のフラグ
    var animated = false
    
    /**
    *  viewDidLoad
    *  画面が描画される際に1度だけ実行される、各種変数などの初期化処理に
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.scrollView.delegate = self
    }
    
    /**
    *  viewWillAppear
    *  画面が描画される度に実行される、各種変数などの初期化処理を呼び出す
    */
    override func viewWillAppear(animated: Bool) {
        self.selectedUserId   = NSString()
        self.userIds          = NSMutableArray()
        self.images           = NSMutableArray()
        self.contentsOfScroll = NSMutableArray()
        self.leftImageIndex   = 0
        self.animated         = false
        
        self.initContents()
        self.updateScrollViewSetting()
    }
    
    /**
    *  initContents
    *  NSUserDefaultsに格納された情報を基にユーザ情報を組み立てる
    */
    func initContents() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var appName = NSBundle.mainBundle().bundleIdentifier
        var dicts   = defaults.persistentDomainForName(appName!) as NSDictionary!
        
        self.maxDisplayViewNum = dicts.count
        
        self.leftViewIndex  = 0
        self.rightViewIndex = self.maxDisplayViewNum - 1
        
        // assetLibraryの取得を同期にするためのスレッド
        var qGlobal: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        var count = 0
        
        for (key, value) in dicts {
            self.userIds.addObject(key)
            
            var btn = UIButton()
            btn.frame = CGRectMake(32, 320 + CGFloat(30 * count), 110, 30)
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            btn.tag = count++
            
            var userName = value["userName"] as NSString!
            btn.setTitle(userName, forState: .Normal)
            btn.setTitleColor(UIColor.blueColor(), forState: .Normal)
            btn.addTarget(self, action: "selectedButton:", forControlEvents: .TouchUpInside)
            self.view.addSubview(btn)
           
            // assetLibraryの処理が非同期であるため、同期処理を行うように変更
            var semaphore = dispatch_semaphore_create(0)
            dispatch_async(qGlobal, {
                var strPath = value["face"] as NSString!
                var facePath = NSURL(string: strPath)
                self.lodingPhotoContent(facePath!, semaphore: semaphore)
            })
            
            // assetLibraryのcallbackを待っている状態
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    }
    
    /**
    * lodingPhotoContent
    * photoContetntsをAssetsから読み出す
    */
    func lodingPhotoContent(path: NSURL!, semaphore: dispatch_semaphore_t) {
        let assetLibrary = ALAssetsLibrary()
        assetLibrary.assetForURL(
            path
            , resultBlock: {
                (asset: ALAsset!) in
                if (asset == nil){
                    return
                }
                
                // 普通の画像を取得するとメモリ的な理由でアプリが落ちてしまうようなので、サムネイル画像を取得
                let image = UIImage(CGImage: asset.thumbnail().takeUnretainedValue())
                self.images.addObject(image!)
                
                // 待ち状態の解除
                dispatch_semaphore_signal(semaphore);
            }
            , failureBlock: {
                (error: NSError!) in
                println("Error!\(error)")
            }
        )
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
        self.leftImageIndex = 0
        
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
        self.leftImageIndex = 0
        
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
        var currentIndex :NSInteger = NSInteger(self.scrollView.contentOffset.x / imageWidth)
        var indexMovement:NSInteger = currentIndex - self.leftImageIndex
        
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
        return (index + incremental + self.maxDisplayViewNum) % self.maxDisplayViewNum
    }

    /**
    * scrollWithDirection
    * 画像の位置を更新する
    *
    * param: scrollDirection 左に移動したのか、右に移動したのかを示すステータス変数
    */
    func scrollWithDirection(scrollDirection:ScrollDirection) {
        var direction :NSInteger = 0
        var viewIndex :NSInteger = 0
        
        if (scrollDirection == ScrollDirection.kScrollDirectionLeft){
            direction = -1
            viewIndex = self.rightViewIndex
        }
        else if (scrollDirection == ScrollDirection.kScrollDirectionRight){
            direction = 1
            viewIndex = self.leftViewIndex
        }
        
        var btn = self.contentsOfScroll[viewIndex] as UIButton
        btn.frame.origin.x += imageWidth * CGFloat(self.images.count * direction)
        
        // 画面に映る最も左のインデックスを更新
        self.leftImageIndex += direction
        
        // 画面外の両端の画像のインデックスを更新
        self.leftViewIndex  = self.addImageIndex(self.leftViewIndex , incremental: direction)
        self.rightViewIndex = self.addImageIndex(self.rightViewIndex, incremental: direction)
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
        
        var index = btn.tag
        self.selectedUserId = self.userIds[index] as NSString
        
        // タップされたボタンに軽いアニメーションを適用する
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
        
        var vc = segue.destinationViewController as ProfileViewController
        vc.userId = self.selectedUserId
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