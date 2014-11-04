//
//  AddUserViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/11/04.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController, UITextFieldDelegate
                           , UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    
    func showPickerView(pickerId: NSInteger) {
        // カラーピッカーの場合は呼び出さない
        if (pickerId == 1){
            return
        }
        
        var picker = UIImagePickerController()
        picker.delegate      = self
        picker.sourceType    = UIImagePickerControllerSourceType.SavedPhotosAlbum
        picker.allowsEditing = false
        picker.view.tag      = pickerId
        
        // ムービーを呼び出す場合は、public.movieを指定
        // ココらへんもう少しうまく場合分けしたい
        if (pickerId == 2){
            picker.mediaTypes = ["public.movie"];
        }
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        switch (picker.view.tag){
          case 2:
            let url = info[UIImagePickerControllerReferenceURL] as NSURL
            self.pickerOfMovie.text = url.absoluteString
            break;
          case 3:
            let url = info[UIImagePickerControllerReferenceURL] as NSURL
            self.pickerOfFace.text = url.absoluteString
            break;
          case 4:
            let url = info[UIImagePickerControllerReferenceURL] as NSURL
            self.pickerOfPicture.text = url.absoluteString
            break;
          default:
            println("指定されたpicker以外からのアクセスがあった")
            break
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        self.showPickerView(textField.tag)
        
        return false
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
}
