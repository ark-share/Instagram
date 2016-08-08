//
//  PostData.swift
//  Instagram
//
//  Created by macpc on 2016/08/05.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: NSDate?
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(snapshot: FIRDataSnapshot, myId: String) {
        id = snapshot.key
        
        let valueDic = snapshot.value as! [String: AnyObject] // [Key: Value]の型のこと
        
        imageString = valueDic["image"] as? String
        image = UIImage(data: NSData(base64EncodedString: imageString!, options: .IgnoreUnknownCharacters)!)
        
        name = valueDic["name"] as? String
        caption = valueDic["caption"] as? String
        
        if let likes = valueDic["likes"] as? [String] {
            self.likes = likes
        }
        
        for likeId in likes {
            if likeId == myId {
                isLiked = true
                break
            }
        }

        date = NSDate(timeIntervalSinceReferenceDate: valueDic["time"] as! NSTimeInterval) // self.いらないんでは
    }
    
}