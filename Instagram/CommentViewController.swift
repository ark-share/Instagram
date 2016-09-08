//
//  CommentViewController.swift
//  Instagram
//
//  Created by macpc on 2016/08/09.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    var post_id: String!
    var selectedImage: UIImage! // 元記事の画像
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBAction func handlePostButton(sender: AnyObject) {
        
        // コメントの保存先はorders以下にする
        let commentRef = FIRDatabase.database().reference().child(CommonConst.PostPATH+"/"+post_id+"/"+CommonConst.CommentPATH)
        
        let name = AppController().getDisplayName() // その時のユーザー名
        
        let time = NSDate.timeIntervalSinceReferenceDate() // 現在時刻
        
        let commentData = [
            "body": commentTextView.text!,
            "name": name,
            "time": time
        ]
        commentRef.childByAutoId().setValue(commentData)
        
        SVProgressHUD.showSuccessWithStatus("投稿しました")
        
//        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil) // 閉じる
        dismissViewControllerAnimated(true, completion: nil) // 閉じる
    }
    
    @IBAction func handleCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil) // 閉じる
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景タップ
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        self.postImageView.image = self.selectedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

}
