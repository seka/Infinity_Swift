//
//  ProfileViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/10/26.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit

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
        
        var triangle = TriangleView(frame: CGRectMake(0, 0, 460, 285), color: self.themeColor)
        self.scrollViewOfProfile.addSubview(triangle)
        self.scrollViewOfProfile.sendSubviewToBack(triangle)
        
        var rectangle = RectangleView(frame: CGRectMake(460, 0, 400, 285), color: self.themeColor)
        self.scrollViewOfProfile.addSubview(rectangle)
        self.scrollViewOfProfile.sendSubviewToBack(rectangle)
        
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
        var contentsSize = CGRectMake(860, 0, 800, 350)
        
        var iv = UIImageView(frame: contentsSize)
        iv.image = UIImage(named: "bt_playmovie_ogata")
        
        self.scrollViewOfProfile.addSubview(iv)
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
        
        UIView.animateWithDuration(0.5, animations: {
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
        
        UIView.animateWithDuration(0.5, animations: {
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