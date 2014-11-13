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
    var userIds = NSMutableArray()
    var colors  = NSMutableArray()
    
    /**
    *  viewWillAppear
    *  画面が描画される度に実行される、各種変数などの初期化処理を呼び出す
    */
    override func viewWillAppear(animated: Bool) {
        self.accessForUserDefaults()
        self.drawButtons()
    }
    
    /**
    * selectedButton
    * ボタンをタップした際に呼び出されるイベント
    *
    * param: btn タップされたボタンオブジェクト
    */
    func selectedButton(btn: UIButton!) {
        var index = btn.tag
        var userId = self.userIds[index] as NSString
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(userId)
        
        self.removeButtons(index)
        self.accessForUserDefaults()
        self.drawButtons()
    }
    
    /**
    * accessForUserDefaults
    * NSUserDefaultsの情報を取得し、配列に格納する
    */
    func accessForUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var appName = NSBundle.mainBundle().bundleIdentifier
        var dicts   = defaults.persistentDomainForName(appName!) as NSDictionary!
        
        if (dicts == nil){
            return
        }
        
        self.userIds = NSMutableArray()
        for (key, dict) in dicts {
            self.userIds.addObject(key)
        }
    }
    
    /**
    * drawButton
    * NSUserDefaultsの情報を基に、ボタンを作成する
    *
    * param: btn タップされたボタンオブジェクト
    */
    func drawButtons() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var appName = NSBundle.mainBundle().bundleIdentifier
        var dicts   = defaults.persistentDomainForName(appName!) as NSDictionary!
        
        var count = 0
        for (key, dict) in dicts {
            var userName = dict["userName"] as NSString!
            
            var btn = UIButton()
            btn.frame = CGRectMake(self.view.bounds.width / 2 - 110, 180 + CGFloat(70 * count), 220, 60)
            btn.tag = count++
            
            btn.setTitle(userName, forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)

            let scanner = NSScanner(string: dict["themeColor"] as NSString)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                var red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                var green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                var blue  = CGFloat( hexValue & 0x0000FF)        / 255.0
                btn.backgroundColor = UIColor(red: red, green:green, blue:blue, alpha:1)
            }
            
            btn.addTarget(self, action: "selectedButton:", forControlEvents: .TouchUpInside)
            self.view.addSubview(btn)
        }
    }
    
    /**
    * removeButtons
    * viewに存在するボタンを削除する
    */
    func removeButtons(index: NSInteger) {
        for view in self.view.subviews {
            if (view.tag == index) {
                view.removeFromSuperview()
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
