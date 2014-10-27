//
//  ProfileViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/10/26.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var id = NSInteger()
    var userName = NSString()
    var nickName = NSString()
    var live     = NSString()
    var keywards = NSArray()
    
    /**
    *  viewDidLoad
    *  画面が描画される際に1度だけ実行される、各種変数などの初期化処理に仕様
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        println("userName:\(userName)")
        
    }
    
    
}