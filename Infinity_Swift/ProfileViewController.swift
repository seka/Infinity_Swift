//
//  ProfileViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/10/26.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit
import MediaPlayer
import AssetsLibrary

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var scrollViewOfProfile: UIScrollView!
    @IBOutlet weak var imageViewOfPageCursor: UIImageView!
    
    // Insert xib
    @IBOutlet weak var labelOfPageTitle : UILabel!
    @IBOutlet weak var imageOfProfile   : UIImageView!
    @IBOutlet weak var labelOfJob       : UILabel!
    @IBOutlet weak var labelOfName      : UILabel!
    @IBOutlet weak var labelOfNickName  : UILabel!
    @IBOutlet weak var labelOfLive      : UILabel!
    @IBOutlet weak var labelOfMessage   : UILabel!
    @IBOutlet weak var labelOfEnneagram : UILabel!
    
    // 前のページから受け継ぐ変数
    var id       = NSString()
    var userName = NSString()
    var nickName = NSString()
    var live     = NSString()
    var message  = NSString()
    var themeColor = UIColor()
    var faceImage  = UIImage()
    
    // UIScrollViewのスクロールサイズを指定
    let maxScrollSize: CGFloat = 2656
    
    // 動画再生に必要な変数（Assetを通してしかアクセスできないため）
    var moviePath = NSURL()
    
    /**
    *  viewDidLoad
    *  画面が描画される際に1度だけ実行される、各種変数などの初期化処理
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var contentSize = CGSizeMake(maxScrollSize, 350)
        self.scrollViewOfProfile.contentSize = contentSize
    }
    
    /**
    *  viewWillAppear
    *  画面が描画される度に実行される、各種変数などの初期化処理
    */
    override func viewWillAppear(animated: Bool) {
        self.updateProfileContents()
        self.updateMovieContents()
        self.updatePhotoContents()
        
        let triangle = TriangleView(frame: CGRectMake(0, 0, 460, 285), color: self.themeColor)
        self.scrollViewOfProfile.addSubview(triangle)
        self.scrollViewOfProfile.sendSubviewToBack(triangle)
        
        let rectangle = RectangleView(frame: CGRectMake(460, 0, 400, 285), color: self.themeColor)
        self.scrollViewOfProfile.addSubview(rectangle)
        self.scrollViewOfProfile.sendSubviewToBack(rectangle)
    }
   
    /**
    * updateProfileContetns
    * xib上のUIの初期化を行う
    */
    func updateProfileContents() {
        self.labelOfPageTitle.text = self.userName + "'s Profile"
        self.imageOfProfile.image  = self.faceImage
        self.labelOfJob.text       = "ENGINEER"
        self.labelOfName.text      = self.userName
        self.labelOfNickName.text  = self.nickName
        self.labelOfLive.text      = "MADE IN " + self.live
        self.themeColor            = .redColor()
    }
    
    /**
    * updateMovieContetns
    * xib上のUIの初期化を行う
    */
    func updateMovieContents() {
        let assetLibrary = ALAssetsLibrary()
        assetLibrary.assetForURL(
            assetUrlOfMovie
            , resultBlock: {
                (asset: ALAsset!) in
                if (asset == nil){
                    return
                }
                
                let rep  = asset.defaultRepresentation()
                var iref = rep.fullResolutionImage().takeUnretainedValue()
                
                // playMovie関数で動画を再生する際に仕様
                self.moviePath = rep.url()
                
                var btn = UIButton()
                btn.frame = CGRectMake(860, 0, 800, 350)
                
                btn.setImage(UIImage(CGImage: iref), forState: .Normal)
                btn.addTarget(self, action: "playMovie:", forControlEvents: .TouchUpInside)

                self.scrollViewOfProfile.addSubview(btn)
            }
            , failureBlock: {
                (error: NSError!) in
                println("Error!\(error)")
            }
        )
   }
    
    /**
    * playMovie
    * 動画をフルスクリーンで再生する
    *
    * param: sender
    */
    func playMovie(sender: UIButton) {
        let mvc         = MPMoviePlayerViewController()
        let vc          = mvc.moviePlayer
        vc.contentURL   = self.moviePath
        vc.scalingMode  = MPMovieScalingMode.Fill
        
        self.presentMoviePlayerViewControllerAnimated(mvc)
        
        vc.setFullscreen(false, animated: true)
        vc.play()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("endMovie:")
            , name: MPMoviePlayerPlaybackDidFinishNotification, object: vc)
    }
    
    /**
    * endMovie
    * 動画の再生終了後の処理
    *
    * param: notification
    */
    func endMovie(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(MPMoviePlayerPlaybackDidFinishNotification)
        
        // self.imageViewOfPageCursor.frameの位置をズラすために、時間を調整している
        // これ以下の秒数を指定すると、指定した位置への移動がうまくいかない
        NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: Selector("goMovie:")
            , userInfo: nil, repeats: false)
    }
    
    /**
    * updatePhotoContetns
    * xib上のUIの初期化を行う
    */
    func updatePhotoContents() {
        let assetLibrary = ALAssetsLibrary()
        assetLibrary.assetForURL(
            assetUrlOfPict
            , resultBlock: {
                (asset: ALAsset!) in
                if (asset == nil){
                    return
                }
                
                let rep  = asset.defaultRepresentation()
                
                let contentsSize = CGRectMake(1720, 0, 800, 350)
                let iv = UIImageView(frame: contentsSize)
                iv.image = UIImage(CGImage: rep.fullResolutionImage().takeRetainedValue())
                
                self.scrollViewOfProfile.addSubview(iv)
            }
            , failureBlock: {
                (error: NSError!) in
                println("Error!\(error)")
            }
        )
   }
    
    /**
    * goProfile
    * プロフィールページへ移動する
    *
    * param: sender
    */
    @IBAction func goProfile(sender: UIButton) {
        let movement = CGPointMake(0, 0)
        self.scrollViewOfProfile.setContentOffset(movement, animated: true)
        
        UIView.animateWithDuration(0.3, animations: {
            let movement = CGRectMake(217, 643, 102, 18)
            self.imageViewOfPageCursor.frame = movement
        })   
    }
    
    /**
    * goMovie
    * ムービーページヘ移動する
    *
    * param: sender
    */
    @IBAction func goMovie(sender: UIButton) {
        let movement = CGPointMake(860, 0)
        self.scrollViewOfProfile.setContentOffset(movement, animated: true)
        
        UIView.animateWithDuration(0.3, animations: {
            let movement = CGRectMake(520, 643, 102, 18)
            self.imageViewOfPageCursor.frame = movement
        })
    }
    
    /**
    * goPhoto
    * ムードボードページヘ移動する
    *
    * param: sender
    */
    @IBAction func goPhoto(sender: UIButton) {
        let movement = CGPointMake(1720, 0)
        self.scrollViewOfProfile.setContentOffset(movement, animated: true)
        
        UIView.animateWithDuration(0.3, animations: {
            let movement = CGRectMake(817, 643, 102, 18)
            self.imageViewOfPageCursor.frame = movement
        })
    }
    
    /**
    * goBack
    * 前のページヘ戻る
    *
    * param: sender 戻るボタン
    */
    @IBAction func goBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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