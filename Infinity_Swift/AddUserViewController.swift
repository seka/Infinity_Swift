//
//  AddUserViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/11/04.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {
    
    // Insert xib
    @IBOutlet weak var textFieldOfUserName  : UITextField!
    @IBOutlet weak var textFieldOfNickName  : UITextField!
    @IBOutlet weak var textFieldOfLiving    : UITextField!
    @IBOutlet weak var textFieldOfMessage   : UITextField!
    @IBOutlet weak var textFieldOfEnneagram : UITextField!
    @IBOutlet weak var pickerOfMovie        : UITextField!
    @IBOutlet weak var pickerOfFace         : UITextField!
    @IBOutlet weak var pickerOfPicture      : UITextField!
    @IBOutlet weak var buttonOfRegist       : UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
