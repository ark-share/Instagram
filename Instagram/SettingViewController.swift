//
//  SettingViewController.swift
//  Instagram
//
//  Created by macpc on 2016/07/21.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func handleChangeButton(sender: AnyObject) {
    }
    
    @IBAction func handleLogoutButton(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ud = NSUserDefaults.standardUserDefaults()
        let name = ud.objectForKey(CommonConst.DisplayNameKey) as! String

        displayNameTextField.text = name
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
