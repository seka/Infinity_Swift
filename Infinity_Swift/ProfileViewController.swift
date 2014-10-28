//
//  ProfileViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/10/26.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var backGroundOfProfile: UIView!
    
    // insert xib
    @IBOutlet weak var labelOfPageTitle : UILabel!
    @IBOutlet weak var imageOfProfile   : UIImageView!
    @IBOutlet weak var labelOfJob       : UILabel!
    @IBOutlet weak var labelOfName      : UILabel!
    @IBOutlet weak var labelOfNickName  : UILabel!
    @IBOutlet weak var labelOfLive      : UILabel!
    @IBOutlet      var labelOfKeywords  : [UILabel]!
    @IBOutlet weak var labelOfMessage   : UILabel!
    @IBOutlet weak var labelOfEnneagram : UILabel!
    
    // 前のページから受け継ぐ変数
    var id       = NSInteger()
    var userName = NSString()
    var nickName = NSString()
    var live     = NSString()
    var keywards = NSArray()
    var themeColor:UIColor = .redColor()
    
    /**
    *  viewDidLoad
    *  画面が描画される際に1度だけ実行される、各種変数などの初期化処理に仕様
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var triangle = TriangleView(frame: CGRectMake(0, 0, 460, 285), color: self.themeColor)
        self.backGroundOfProfile.addSubview(triangle)
        self.backGroundOfProfile.sendSubviewToBack(triangle)
        
        var rectangle = Rectangle(frame: CGRectMake(460, 0, 400, 285), color: self.themeColor)
        self.backGroundOfProfile.addSubview(rectangle)
        self.backGroundOfProfile.sendSubviewToBack(rectangle)
        
        self.updateContents()
    }
   
    /**
    * updateContents
    * xib上のUIを修正
    */
    func updateContents() {
        self.labelOfPageTitle.text = self.userName + "'s Profile"
        self.imageOfProfile.image  = UIImage(named: "foto_angie_s")!
        self.labelOfJob.text       = "ENGINEER"
        self.labelOfName.text      = self.userName
        self.labelOfNickName.text  = self.nickName
        self.labelOfLive.text      = "MADE IN " + self.live
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