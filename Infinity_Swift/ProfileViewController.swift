//
//  ProfileViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/10/26.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AssetsLibrary

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var scrollViewOfProfile: UIScrollView!
    @IBOutlet weak var imageViewOfPageCursor: UIImageView!
    
    var testURL = "file:///Users/sekaryoushin/Library/Developer/CoreSimulator/Devices/A1B65DFE-FC90-42F7-8497-7B6CD9CECA03/data/Containers/Data/Application/FC091FF0-F26F-4E0D-9F8A-79FDA643BACA/tmp/trim.8D8ED8D1-0702-4179-B7C7-BAEDDEF43193.MOV"
    
    var testURL2 = "https://dl.dropboxusercontent.com/u/39295401/%E5%8B%95%E7%94%BB%202014-09-22%2018%2002%2042.mov"
    
    
    // Insert xib
    @IBOutlet weak var labelOfPageTitle : UILabel!
    @IBOutlet weak var imageOfProfile   : UIImageView!
    @IBOutlet weak var labelOfJob       : UILabel!
    @IBOutlet weak var labelOfName      : UILabel!
    @IBOutlet weak var labelOfNickName  : UILabel!
    @IBOutlet weak var labelOfLive      : UILabel!
    @IBOutlet      var labelOfKeywords  : [UILabel]!
    @IBOutlet weak var labelOfMessage   : UILabel!
    @IBOutlet weak var labelOfEnneagram : UILabel!
    
    var maxScrollSize: CGFloat = 2656
    
    // 前のページから受け継ぐ変数
    var id       = NSInteger()
    var userName = NSString()
    var nickName = NSString()
    var live     = NSString()
    var keywards = NSArray()
    var themeColor = UIColor()
    
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
        
        var triangle = TriangleView(frame: CGRectMake(0, 0, 460, 285), color: self.themeColor)
        self.scrollViewOfProfile.addSubview(triangle)
        self.scrollViewOfProfile.sendSubviewToBack(triangle)
        
        var rectangle = RectangleView(frame: CGRectMake(460, 0, 400, 285), color: self.themeColor)
        self.scrollViewOfProfile.addSubview(rectangle)
        self.scrollViewOfProfile.sendSubviewToBack(rectangle)
    }
   
    /**
    * updateProfileContetns
    * xib上のUIの初期化を行う
    */
    func updateProfileContents() {
        self.labelOfPageTitle.text = self.userName + "'s Profile"
        self.imageOfProfile.image  = UIImage(named: "foto_angie_s")!
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
        
        let fileURL = NSBundle.mainBundle().URLForResource("ogata_movie", withExtension: "mp4")
        
        var mvc = MPMoviePlayerViewController()
        mvc.view.frame = CGRectMake(860, 0, self.scrollViewOfProfile.bounds.width, self.scrollViewOfProfile.bounds.height)
        
        var vc = mvc.moviePlayer
        vc.contentURL     = fileURL
        vc.view.frame     = CGRectMake(865, 10, 180, 110)
        vc.scalingMode    = MPMovieScalingMode.Fill
        vc.shouldAutoplay = false
        vc.setFullscreen(true, animated: true)
        
        self.presentMoviePlayerViewControllerAnimated(mvc)
        self.scrollViewOfProfile.addSubview(vc.view)
        
        /*　フルスクリーン
        vc.view.frame = UIApplication.sharedApplication().keyWindow?.bounds as CGRect!
        UIApplication.sharedApplication().keyWindow?.addSubview(vc.view)
        */
        
        /*
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        picker.mediaTypes = ["public.movie"];
        picker.allowsEditing = false
        presentViewController(picker, animated: true, completion: nil)
        */
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        println(UIImagePickerControllerMediaURL)
        println("----------")
        println(info)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        var vc = MPMoviePlayerController()
        vc.contentURL = info[UIImagePickerControllerMediaURL] as NSURL
        // vc.view.frame = CGRectMake(860, 0, 800, 350)
        vc.view.frame = CGRectMake(0, 0, 800, 350)
        
        
        self.scrollViewOfProfile.addSubview(vc.view)
        
        vc.play()


    }

    /**
    * updatePhotoContetns
    * xib上のUIの初期化を行う
    */
    func updatePhotoContents() {
        var contentsSize = CGRectMake(1720, 0, 800, 350)
        
        var iv = UIImageView(frame: contentsSize)
        iv.image = UIImage(named: "moodboard_angie")
        
        self.scrollViewOfProfile.addSubview(iv)
    }
    
    /**
    * goProfile
    * プロフィールページへ移動する
    *
    * param: sender
    */
    @IBAction func goProfile(sender: UIButton) {
        var movement = CGPointMake(0, 0)
        self.scrollViewOfProfile.setContentOffset(movement, animated: true)
        
        UIView.animateWithDuration(0.5, animations: {
            var movement = CGRectMake(217, 643, 102, 18)
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
        var movement = CGPointMake(860, 0)
        self.scrollViewOfProfile.setContentOffset(movement, animated: true)
        
        UIView.animateWithDuration(0.3, animations: {
            var movement = CGRectMake(520, 643, 102, 18)
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
        var movement = CGPointMake(1720, 0)
        self.scrollViewOfProfile.setContentOffset(movement, animated: true)
        
        UIView.animateWithDuration(0.3, animations: {
            var movement = CGRectMake(817, 643, 102, 18)
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