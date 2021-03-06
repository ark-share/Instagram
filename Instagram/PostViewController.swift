//
//  PostViewController.swift
//  Instagram
//
//  Created by macpc on 2016/07/21.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PostViewController: UIViewController {

    var image: UIImage!
    
    @IBOutlet weak var imageVew: UIImageView!
    @IBOutlet weak var textField: UITextField!

    @IBAction func handlePostButton(sender: AnyObject) {
        
        // どこに保存？
        let postRef = FIRDatabase.database().reference().child(CommonConst.PostPATH)
        
        let imageData = UIImageJPEGRepresentation(imageVew.image!, 0.5)
        
        let name = AppController().getDisplayName() // その時のユーザー名
        
        let time = NSDate.timeIntervalSinceReferenceDate() // 現在時刻
        
        let postData = [
            "caption": textField.text!,
            "image": imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength), // テキストで保存
            "name": name,
            "time": time
        ]
        postRef.childByAutoId().setValue(postData)
        
        SVProgressHUD.showSuccessWithStatus("投稿しました")
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil) // 閉じる
    }
    
    @IBAction func handleCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil) // 閉じる
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景タップ
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)

        // 受け取った画像をImageViewに表示
        imageVew.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func dismissKeyboard() {
        view.endEditing(true)
    }

}
