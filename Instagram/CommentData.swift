//
//  CommentData.swift
//  Instagram
//
//  Created by macpc on 2016/08/09.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CommentData: NSObject {
    var id: String?
    var body: String?
    var date: NSDate?
    var name: String?
    //var post_id: String?

    init(snapshot: FIRDataSnapshot) { //, myId: String 自分が投稿したコメントだけハイライトしたい、とかの場合myIDを使って加工できる
        id = snapshot.key
        
        let valueDic = snapshot.value as! [String: AnyObject] // [Key: Value]の型のこと as!は、実行時エラーになる可能性がある
        
        body = valueDic["body"] as? String // as?は、nilになる可能性がある
        name = valueDic["name"] as? String
        //post_id = valueDic["post_id"] as? String
        
        date = NSDate(timeIntervalSinceReferenceDate: valueDic["time"] as! NSTimeInterval)
    }
    
}