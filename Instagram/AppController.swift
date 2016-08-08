//
//  AppController.swift
//  Instagram
//
//  Created by macpc on 2016/08/04.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import Foundation
import UIKit

class AppController: NSObject {
    
    
    // 表示名
    func setDisplayName(name: String) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setValue(name, forKey: CommonConst.DisplayNameKey)
        ud.synchronize()
    }
    func getDisplayName() -> String {
        let ud = NSUserDefaults.standardUserDefaults()
        let name = ud.objectForKey(CommonConst.DisplayNameKey) as! String
        return name
    }
    
    func openModal(controller: UIViewController, name: String) {
        let vc = controller.storyboard?.instantiateViewControllerWithIdentifier(name)
        controller.presentViewController(vc!, animated: true, completion: nil)
    }
    
}