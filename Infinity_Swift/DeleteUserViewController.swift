//
//  DeleteUserViewController.swift
//  Infinity_Swift
//
//  Created by PxP_ss on 2014/11/13.
//  Copyright (c) 2014年 pxp_ss. All rights reserved.
//

import UIKit

class DeleteUserViewController: UIViewController {
    
    // NSUserDefaultsから取得するユーザ情報
    var userIds   = NSMutableArray()
    var userNames = NSMutableArray()
    var colors    = NSMutableArray()

    var buttons : NSMutableArray?
    
    /**
    *  viewWillAppear
    *  画面が描画される度に実行される、各種変数などの初期化処理を呼び出す
    */
    override func viewWillAppear(animated: Bool) {
        self.accessForUserDefaults()
        self.drawButtons()
    }
    
    /**
    * accessForUserDefaults
    * NSUserDefaultsの情報を取得し、配列に格納する
    */
    func accessForUserDefaults() {
        self.userIds   = NSMutableArray()
        self.userNames = NSMutableArray()
        self.colors    = NSMutableArray()

        var defaults = NSUserDefaults.standardUserDefaults()
        var appName  = NSBundle.mainBundle().bundleIdentifier
        var dicts    = defaults.persistentDomainForName(appName!) as NSDictionary?
        
        if (dicts == nil){
            return
        }
        
        for (key, dict) in dicts! {
            self.userIds.addObject(key)
            self.userNames.addObject(dict["userName"] as NSString)
            self.colors.addObject(dict["themeColor"] as NSString)
        }
    }
    
    /**
    * drawButtons
    * NSUserDefaultsの情報を基に、ボタンを作成する
    *
    * param: btn タップされたボタンオブジェクト
    */
    func drawButtons() {
        if (self.userIds.count < 1 || self.userNames.count < 1){
            return
        }
        
        self.buttons = NSMutableArray()
        
        for i in 0 ..< self.userIds.count {
            var btn = UIButton()
            btn.frame = CGRectMake(self.view.bounds.width / 2 - 110, 180 + CGFloat(70 * i), 220, 60)
            btn.tag = i
            
            btn.addTarget(self, action: "selectedButton:", forControlEvents: .TouchUpInside)
            btn.setTitle(self.userNames[i] as NSString, forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)

            let scanner = NSScanner(string: self.colors[i] as NSString)
            var hexValue: CUnsignedLongLong = 0
            if (scanner.scanHexLongLong(&hexValue)) {
                var red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                var green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                var blue  = CGFloat( hexValue & 0x0000FF)        / 255.0
                btn.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
            }

            self.buttons!.addObject(btn)

            self.view.addSubview(btn)
        }
    }
    
    /**
    * selectedButton
    * ボタンをタップした際に呼び出されるイベント, ボタンに対応したデータをNSUserDefaultsから削除する
    *
    * param: btn タップされたボタンオブジェクト
    */
    func selectedButton(btn: UIButton!) {
        self.removeButtons(btn)
        
        var index  = btn.tag
        var userId = self.userIds[index] as NSString
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(userId)
        defaults.synchronize()
        
        self.accessForUserDefaults()
        self.drawButtons()
    }
    
    /**
    * removeButtons
    * viewに存在するボタンをすべて削除する
    */
    func removeButtons(btn: UIButton) {
        for view in self.view.subviews {
            for btn in self.buttons! {
                if (btn as UIButton == view as NSObject){
                    view.removeFromSuperview()
                }
            }
        }
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
        
        super.didReceiveMemoryWarning()
        
    }
}
