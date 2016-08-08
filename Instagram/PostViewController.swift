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

        // 受け取った画像をImageViewに表示
        imageVew.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
