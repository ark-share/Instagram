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
    var post_id: String?

    init(snapshot: FIRDataSnapshot, myId: String) {
        id = snapshot.key
        
        let valueDic = snapshot.value as! [String: AnyObject] // [Key: Value]の型のこと
        
        body = valueDic["body"] as? String
        name = valueDic["name"] as? String
        
        date = NSDate(timeIntervalSinceReferenceDate: valueDic["time"] as! NSTimeInterval)
    }
    
}