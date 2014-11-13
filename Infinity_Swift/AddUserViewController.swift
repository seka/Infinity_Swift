//
//  AddUserViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/11/04.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate
                           , UIImagePickerControllerDelegate, ThemeColorPickerDelegate {
    
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
    
    /**
    *  viewDidLoad
    *  画面が描画される際に1度だけ実行される、各種変数などの初期化処理
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.pickerOfThemeColor.delegate = self
        self.pickerOfMovie.delegate      = self
        self.pickerOfFace.delegate       = self
        self.pickerOfPicture.delegate    = self
    }
    
    /**
    * registUserInfo
    * NSUserDefaltsに入力されたProfileを保存する
    * TODO:入力値チェックをしていないので、余裕があったらやりたい
    *
    * param: sender Regist_登録ボタン
    */
    @IBAction func registUserInfo(sender: UIButton) {
        var alert = UIAlertView()
        
        if (self.textFieldOfUserName.text == "" || self.textFieldOfNickName.text == "" || self.textFieldOfLiving.text == ""
        || self.textFieldOfMessage.text == "" || self.textFieldOfEnneagram.text == "" || self.pickerOfThemeColor.text == ""
        || self.pickerOfMovie.text == "" || self.pickerOfFace.text == "" || self.pickerOfPicture.text == ""){
            alert.message = "未設定の項目があります"
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uuid = NSUUID().UUIDString
        var dict = [
            "userName"    : self.textFieldOfUserName.text
            , "nickName"  : self.textFieldOfNickName.text
            , "living"    : self.textFieldOfLiving.text
            , "message"   : self.textFieldOfMessage.text
            , "ennegram"  : self.textFieldOfEnneagram.text
            , "themeColor": self.pickerOfThemeColor.text
            , "movie"     : self.pickerOfMovie.text
            , "face"      : self.pickerOfFace.text
            , "picture"   : self.pickerOfPicture.text
        ]
        
        defaults.setObject(dict, forKey: uuid)
        defaults.synchronize()
        
        alert.message = "登録が完了しました！"
        alert.addButtonWithTitle("OK")
        alert.show()
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
    * showPickerView
    * picker~を選択された際に各種のUIPickerを描画する
    *
    * param: pickerId
    */
    func showPickerView(pickerId: NSInteger) {
        // カラーピッカーの場合は呼び出さない
        if (pickerId == 1){
            var colorPicker = ThemeColorPicker(frame: self.view.frame)
            colorPicker.delegate = self
            self.view.addSubview(colorPicker)
            self.view.bringSubviewToFront(colorPicker)
            return
        }
        
        var imagePicker = UIImagePickerController()
        imagePicker.delegate      = self
        imagePicker.sourceType    = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePicker.allowsEditing = false
        imagePicker.view.tag      = pickerId
        
        // ムービーを呼び出す場合は、public.movieを指定
        // TODO:ココらへんもう少しうまく場合分けしたい
        if (pickerId == 2){
            imagePicker.mediaTypes = ["public.movie"];
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    /**
    * themeColorPicker
    * ThemeColorPickerを選択後の処理
    *
    * param: picker     ThemeColorPicker
    * param: themeColor UIcolorまたはNil
    */
    func themeColorPicker(picker: ThemeColorPicker, themeColor: UIColor?) {
        if ((themeColor) != nil){
            var hexColor = picker.HSVtoHexString(themeColor!) as NSString
            self.pickerOfThemeColor.text = hexColor
        }
        
        picker.removeFromSuperview()
    }
    
    /**
    * imagePickerController
    * ImagePickerControllerを選択後の処理
    *
    * param: picker UIImagePicker
    * param: info   ピッカーによって選択された写真・または動画情報
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let url = info[UIImagePickerControllerReferenceURL] as NSURL
        
        // swiftでは自動的にbreakされる？
        switch (picker.view.tag){
          case 2:
            self.pickerOfMovie.text   = url.absoluteString
          case 3:
            self.pickerOfFace.text    = url.absoluteString
          case 4:
            self.pickerOfPicture.text = url.absoluteString
          default:
            println("指定されたpicker以外からのアクセスがあった")
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    * textFieldShouldBeginEditing
    * テキストフィールドがタップされたときのイベント
    * picker~から始まるtextFieldは、イベントをキャンセルして各種のPickerを表示する
    *
    * param  : textField
    * returns: キーボードの表示・非表示を表すbool値
    */
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        self.showPickerView(textField.tag)
        
        return false
    }
    
    /**
    * didReciveMemoryWarning
    * メモリが圧迫されると警告を示す
    */
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
}
