//
//  ViewController.swift
//  Instagram
//
//  Created by macpc on 2016/07/21.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//


import Firebase
//import FirebaseAuth なくていい

import UIKit
import ESTabBarController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupTab()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        if FIRAuth.auth()?.currentUser != nil { //let user =
//            let name = user.displayName // String?
//            let email = user.email // String?
//            let photoUrl = user.photoURL // NSURL?
//            let uid = user.uid // String
//            print(name! + " " + email! + " " + uid)

            setupTab()
            

        }
        else {
            print("No user is signed in.")
            // メソッドが終了してから呼ぶ方法
            dispatch_async(dispatch_get_main_queue()) {
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(loginViewController!, animated: true, completion: nil) // モーダルで表示
            }
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupTab() {
        let tabBarController = ESTabBarController(tabIconNames: ["home", "camera", "setting"])
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        
        // tabをselfに追加
        addChildViewController(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.bounds
        tabBarController.didMoveToParentViewController(self)
        
        
        // タップした時のView
        let homeViewController = storyboard?.instantiateViewControllerWithIdentifier("Home")
        let settingViewController = storyboard?.instantiateViewControllerWithIdentifier("Setting")
        tabBarController.setViewController(homeViewController, atIndex: 0)
        tabBarController.setViewController(settingViewController, atIndex: 2)
        
        // 中央のタブはボタンとして扱う
        tabBarController.highlightButtonAtIndex(1)
        tabBarController.setAction({
            let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageSelect")
            self.presentViewController(imageViewController!, animated: true, completion: nil)
            
            }, atIndex: 1)
    }

}

