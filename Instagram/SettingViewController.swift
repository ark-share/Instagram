//
//  SettingViewController.swift
//  Instagram
//
//  Created by macpc on 2016/07/21.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ESTabBarController

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func handleChangeButton(sender: AnyObject) {
        if let name = displayNameTextField.text {
            // 未入力なら何もしない
            if name.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("表示名を入力してください")
                return
            }
            
            
            // firebaseに保存
            if let request = FIRAuth.auth()?.currentUser?.profileChangeRequest() {
                request.displayName = name
                request.commitChangesWithCompletion({ error in
                    if error != nil {
                        print(error)
                    } else {
                        AppController().setDisplayName(name)
                        
                        // HUDで官僚を知らせる
                        SVProgressHUD.showSuccessWithStatus("表示名を変更しました")
                        
                        // キーボードを閉じる
                        //self.view.endEditing(true)
                    }
                })
            }

        }

    }
    
    @IBAction func handleLogoutButton(sender: AnyObject) {
        // sign out
        try! FIRAuth.auth()?.signOut()
        
        // ログインのモーダルを出しておく
        AppController().openModal(self, name: "Login")
        
        let tabBarController = parentViewController as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ud = NSUserDefaults.standardUserDefaults()
        let name = ud.objectForKey(CommonConst.DisplayNameKey) as! String

        displayNameTextField.text = name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
