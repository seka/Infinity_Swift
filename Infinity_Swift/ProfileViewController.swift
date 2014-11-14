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
    
    @IBOutlet weak var scrollViewOfProfile  : UIScrollView!
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
    var userId = NSString()
    var themeColor = UIColor()
    
    // UIScrollViewのスクロールサイズを指定
    let maxScrollSize: CGFloat = 2656
    
    // 動画再生に必要な変数（Assetを通してしかアクセスできないため）
    var assetUrlOfMovie : NSURL?
    var moviePath       : NSURL?
    
    // ムードボードに必要な変数（Assetを通してしかアクセスできないため）
    var assetUrlOfPict : NSURL?
 
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
        let defaults = NSUserDefaults.standardUserDefaults()
        let dict = defaults.objectForKey(self.userId) as NSDictionary
        
        self.labelOfPageTitle.text = dict["userName"] as NSString + "'s Profile"
        self.labelOfName.text      = dict["userName"] as NSString
        self.labelOfNickName.text  = dict["nickName"] as NSString
        self.labelOfMessage.text   = dict["message"]  as NSString
        self.labelOfEnneagram.text = "Enneagram " + (dict["ennegram"] as NSString)
        self.labelOfLive.text      = "MADE IN "   + (dict["living"]   as NSString)
        self.labelOfJob.text       = "ENGINEER"
        
        self.assetUrlOfMovie = NSURL(string: dict["movie"] as NSString)
        self.assetUrlOfPict  = NSURL(string: dict["picture"] as NSString)
        
        let scanner = NSScanner(string: dict["themeColor"] as NSString)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexLongLong(&hexValue) {
            var red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            var green = CGFloat((hexValue & 0x00FF00) >>  8) / 255.0
            var blue  = CGFloat( hexValue & 0x0000FF)        / 255.0
            self.themeColor = UIColor(red:red, green:green, blue:blue, alpha:1.0)
        }

        self.accessForAssetURL(NSURL(string: dict["face"] as NSString)!, {
            (asset: ALAsset!) in
            let image = UIImage(CGImage: asset!.thumbnail().takeUnretainedValue())
            self.imageOfProfile.image = image
            
            return "Success"
        })
    }
    
    /**
    * updatePhotoContetns
    * xib上のUIの初期化を行う
    */
    func updatePhotoContents() {
        self.accessForAssetURL(assetUrlOfPict!, {
            (asset: ALAsset!) in
            let rep  = asset.defaultRepresentation()
            
            let contentsSize = CGRectMake(1720, 0, 800, 350)
            let iv = UIImageView(frame: contentsSize)
            iv.image = UIImage(CGImage: rep.fullResolutionImage().takeRetainedValue())
            
            self.scrollViewOfProfile.addSubview(iv)
            
            return "Success"
        })
    }
    
    /**
    * updateMovieContetns
    * xib上のUIの初期化を行う
    */
    func updateMovieContents() {
        self.accessForAssetURL(assetUrlOfMovie!, {
            (asset: ALAsset!) in
            let rep  = asset.defaultRepresentation()
            var iref = rep.fullResolutionImage().takeUnretainedValue()
            
            // playMovie関数で動画を再生する際に使用
            self.moviePath = rep.url()
            
            var btn = UIButton()
            btn.frame = CGRectMake(860, 0, 800, 350)
            
            btn.setImage(UIImage(CGImage: iref), forState: .Normal)
            btn.addTarget(self, action: "playMovie:", forControlEvents: .TouchUpInside)

            self.scrollViewOfProfile.addSubview(btn)
        
            return "Success"
        })
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
        
        // 動画再生が終了された時、endMovieを呼び出す
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
    * accessForAssetURL
    * assetsにアクセスするためのラッパー
    *
    * param: assetPath Asset://~から始まるPath
    * param: callback
    */
    func accessForAssetURL(assetPath: NSURL, callback: (ALAsset) -> AnyObject?) {
        let assetLibrary = ALAssetsLibrary()
        assetLibrary.assetForURL(
            assetPath
            , resultBlock: {
                (asset: ALAsset?) in
                if (asset == nil){
                    return
                }
                callback(asset!)
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
    * TODO: 下のやつとまとめて関数化できそう...?
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