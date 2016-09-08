//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by macpc on 2016/08/05.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class PostTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate { // cellの中でさらにTableView

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! // コメントTable
    
    var postData: PostData!
    
    var commentArray: [CommentData] = [] // カスタムTableViewCellでは1件の箱。Tableではそれを複数保持
    
    // awakeFromNibでは初期化系のことはやらない方がいいみたい。ここでのCellごとに呼ばれるわけではない？
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil) // Xibファイルの名前
        tableView.registerNib(nib, forCellReuseIdentifier: "CommentCell")
        tableView.rowHeight = UITableViewAutomaticDimension // cellの高さは自動
        
        // commentsに要素が追加されたらクロージャ呼び出す ＞ここだとpostDataがnilになってデータが取れないので、layoutSubviewsで呼び出すように変更
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 表示の時呼ばれる
    override func layoutSubviews() {
    
        if postData != nil {
            postImageView.image = postData.image!
            captionLabel.text = "\(postData.name!) : \(postData.caption!) : [\(postData.id!)]"
            
            
            let likeNumber = postData.likes.count
            likeLabel.text = "\(likeNumber)"
            
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "ja_JP")
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateString:String = formatter.stringFromDate(postData.date!)
            dateLabel.text = dateString
            
            if postData.isLiked {
                let buttonImage = UIImage(named: "like_exist")
                likeButton.setImage(buttonImage, forState: UIControlState.Normal)
            }
            else {
                let buttonImage = UIImage(named: "like_none")
                likeButton.setImage(buttonImage, forState: UIControlState.Normal)
            }
            
            
            FIRDatabase.database().reference().child(CommonConst.PostPATH+"/"+postData.id!+"/"+CommonConst.CommentPATH).observeEventType(.ChildAdded, withBlock: { snapshot in
                
                if self.postData != nil {
                    
                    // CommentDataにデータを設定する
                    //if let uid = FIRAuth.auth()?.currentUser?.uid { // 自分の投稿をハイライトしたいとかないならauthは不要
                    
                    // わざわざpost_idで照らしあわせる必要はない　＞firebaseに直接参照できる
                    let commentData = CommentData(snapshot: snapshot) //myId: uid
                    self.commentArray.insert(commentData, atIndex: 0)
                    
                    self.tableView.reloadData() // テーブル再表示
                    //}
                }
                
            })
        }
        
        super.layoutSubviews()
    }
    
    // コメントTable
    // delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    // セルの内容を返す
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // セルを取得してデータ設定
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentTableViewCell
        cell.commentData = commentArray[indexPath.row]
        
        cell.layoutIfNeeded()
        return cell
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension // セルの高さを自動で変更する
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200 // UITableViewAutomaticDimension // 実際の高さ
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true) // 選択状態を解除するだけ
    }
}
