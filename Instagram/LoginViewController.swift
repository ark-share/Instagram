//
//  LoginViewController.swift
//  Instagram
//
//  Created by macpc on 2016/07/21.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    // ログインbutton
    @IBAction func handleLoginButton(sender: AnyObject) {
        
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            // どれか未入力なら何もしない
            if address.characters.isEmpty || password.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("必須項目を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            
            // ログイン処理
            FIRAuth.auth()?.signInWithEmail(address, password: password, completion: { (user, error) in
                if error != nil {
                    SVProgressHUD.showErrorWithStatus("エラー")
                    print(error)
                } else {
                    // Firebaseからログインユーザの表示名を取得
                    if let displayName = user?.displayName {
                        self.setDisplayName(displayName)
                    }
                    
                    // HUDを消す
                    SVProgressHUD.dismiss()
                    
                    // 次はViewControllerの viewDisAppear:へ
                    self.dismissViewControllerAnimated(true, completion: nil) // 画面閉じる
                    
                }
            })
            
        }

    }
    // アカウント作成button
    @IBAction func handleCreateAccountButton(sender: AnyObject) {

        
        // オプショナルバインディング（宣言、nilチェックとアンラップ）
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            // どれか未入力なら何もしない
            if address.characters.isEmpty || password.characters.isEmpty || displayName.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("必須項目を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            
            // アカウント作成処理
            FIRAuth.auth()?.createUserWithEmail(address, password: password, completion: { (user, error) in
                if error != nil {
                    SVProgressHUD.showErrorWithStatus("エラー")
                    print(error)
                } else {
                    // 作成できたらログインする
                    FIRAuth.auth()?.signInWithEmail(address, password: password, completion: { (user, error) in
                        if error != nil {
                            SVProgressHUD.showErrorWithStatus("エラー")
                            print(error)
                        } else {
                            // Firebaseに表示名を保存
                            if let user = user {
                                let request = user.profileChangeRequest()
                                request.displayName = displayName
                                request.commitChangesWithCompletion({ error in
                                    if error != nil {
                                        print(error)
                                    } else {
                                        self.setDisplayName(displayName)
                                        
                                        // HUDを消す
                                        SVProgressHUD.dismiss()
                                        
                                        // 次はViewControllerの viewDisAppear:へ
                                        self.dismissViewControllerAnimated(true, completion: nil) // 画面閉じる
                                    }
                                })
                            }
                        }
                    })
                }
            })
            
        }
        else {
            print("addr,pass,nameどれかnil")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // 表示名の保存
    func setDisplayName(name: String) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setValue(name, forKey: CommonConst.DisplayNameKey)
        ud.synchronize()
    }
    
}
