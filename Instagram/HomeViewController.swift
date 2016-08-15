//
//  HomeViewController.swift
//  Instagram
//
//  Created by macpc on 2016/07/21.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = [] // カスタムTableViewCellでは1件の箱。Tableではそれを複数保持することになる。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil) // Xibファイルの名前
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension // cellの高さは自動
        
        // postsに要素が追加されたらクロージャ呼び出す
        FIRDatabase.database().reference().child(CommonConst.PostPATH).observeEventType(.ChildAdded, withBlock: { snapshot in
            
            // PostDataにデータを設定する
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                let postData = PostData(snapshot: snapshot, myId: uid)
                self.postArray.insert(postData, atIndex: 0)
                
                self.tableView.reloadData() // テーブル再表示
            }
            
        })
        
        // postsが変更されたら 削除＞その後追加
        FIRDatabase.database().reference().child(CommonConst.PostPATH).observeEventType(.ChildChanged, withBlock: { snapshot in
        
            // PostDataにデータを設定する
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                let postData = PostData(snapshot: snapshot, myId: uid)
                
                
                // まず同じidのデータを探す
                var index: Int = 0
                for post in self.postArray {
                    if post.id == postData.id {
                        index = self.postArray.indexOf(post)! // 要素からインデクスを得る
                        break
                    }
                }
                
                self.postArray.removeAtIndex(index)
                self.postArray.insert(postData, atIndex: index)
                
                //self.tableView.reloadData() // テーブル再表示
                // 該当のセルだけ更新
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    // セルの内容を返す
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルを取得してデータ設定
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostTableViewCell
        cell.postData = postArray[indexPath.row]
        
        // いいねアクションを設定する
        cell.likeButton.addTarget(self, action: #selector(HomeViewController.handleLikeButton(_:event:)), forControlEvents:  UIControlEvents.TouchUpInside)
        // コメントアクション
        cell.commentButton.addTarget(self, action: #selector(HomeViewController.handleCommentButton(_:event:)), forControlEvents:  UIControlEvents.TouchUpInside)
        
        
        cell.layoutIfNeeded()
        return cell
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension // セルの高さを自動で変更する
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true) // 選択状態を解除するだけ
    }
    
    
    // カスタムセル内のいいねボタン
    func handleLikeButton(sender: UIButton, event: UIEvent) {
        
        // タップ位置からindexPathを求める
        let touch = event.allTouches()?.first
        let point = touch!.locationInView(self.tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        let postData = postArray[indexPath!.row]
        
        // firebaseに保存する準備
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if postData.isLiked {
                // すでにいいねしていた場合
                var index = -1
                for likeId in postData.likes {
                    if likeId == uid {
                        // 削除するためのインデクスを保持しておく
                        index = postData.likes.indexOf(likeId)!
                        break
                    }
                }
                postData.likes.removeAtIndex(index)
            }
            else {
                postData.likes.append(uid)
                SVProgressHUD.showSuccessWithStatus("いいね！しました")
            }
            
            let imageString = postData.imageString
            let name = postData.name
            let caption = postData.caption
            let time = (postData.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval
            let likes = postData.likes
            
            // 辞書形式にしてfirebaseへ保存
            let post = ["caption": caption!, "image": imageString!, "name": name!, "time": time, "likes": likes]
            let postRef = FIRDatabase.database().reference().child(CommonConst.PostPATH)
            postRef.child(postData.id!).setValue(post)
            
        }
    }
    
    // カスタムセル内のコメントボタン
    func handleCommentButton(sender: UIButton, event: UIEvent) {
        
        // タップ位置からindexPathを求める
        let touch = event.allTouches()?.first
        let point = touch!.locationInView(self.tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        let postData = postArray[indexPath!.row]
        
        
        let commentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Comment") as! CommentViewController
        commentViewController.post_id = postData.id
        self.presentViewController(commentViewController, animated: true, completion: nil) // モーダルで表示
    }
}
