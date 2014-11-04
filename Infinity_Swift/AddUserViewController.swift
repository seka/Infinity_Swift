//
//  AddUserViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/11/04.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController, UITextFieldDelegate {
    
    // Insert xib
    @IBOutlet weak var textFieldOfUserName  : UITextField!
    @IBOutlet weak var textFieldOfNickName  : UITextField!
    @IBOutlet weak var textFieldOfLiving    : UITextField!
    @IBOutlet weak var textFieldOfMessage   : UITextField!
    @IBOutlet weak var textFieldOfEnneagram : UITextField!
    @IBOutlet weak var pickerOfThemeColor   : UITextField!
    @IBOutlet weak var pickerOfMovie        : UITextField!
    @IBOutlet weak var pickerOfFace         : UITextField!
    @IBOutlet weak var pickerOfPicture      : UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerOfThemeColor.delegate = self
        self.pickerOfMovie.delegate      = self
        self.pickerOfFace.delegate       = self
        self.pickerOfPicture.delegate    = self
    }   
    
    @IBAction func registUserInfo(sender: UIButton) {
    }

    
    @IBAction func goBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
