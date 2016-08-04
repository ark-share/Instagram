//
//  AppController.swift
//  Instagram
//
//  Created by macpc on 2016/08/04.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import Foundation
import UIKit

// AppController.setXX()はダメで、AppController().setXX()なら参照できた
class AppController {
    
    
    // 表示名の保存
    func setDisplayName(name: String) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setValue(name, forKey: CommonConst.DisplayNameKey)
        ud.synchronize()
    }
    
    func openModal(controller: UIViewController, name: String) {
        let vc = controller.storyboard?.instantiateViewControllerWithIdentifier(name)
        controller.presentViewController(vc!, animated: true, completion: nil)
    }
    
}