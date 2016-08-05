//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by macpc on 2016/07/21.
//  Copyright © 2016年 hiroshi.ohara. All rights reserved.
//

import UIKit
import SVProgressHUD

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AdobeUXImageEditorViewControllerDelegate {
    
    // ライブラリ
    @IBAction func handleLibraryButton(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)) {
            let p = UIImagePickerController()
            p.delegate = self
            p.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(p, animated: true, completion: nil)
        }
        else {
            SVProgressHUD.showErrorWithStatus("起動できません")
        }
    }
    // カメラ
    @IBAction func handleCameraButton(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let p = UIImagePickerController()
            p.delegate = self
            p.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(p, animated: true, completion: nil)
        }
        else {
            SVProgressHUD.showErrorWithStatus("起動できません")
        }
    }
    @IBAction func handleCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil) // 閉じる
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 画像を選択
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        SVProgressHUD.showSuccessWithStatus("ImageEditorを開きます")
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            dispatch_async(dispatch_get_main_queue()) {
                let adobe = AdobeUXImageEditorViewController(image: image)
                adobe.delegate = self
                self.presentViewController(adobe, animated: true, completion: nil)
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil) // 閉じる
    }
    
    // 選択をキャンセル
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil) // 閉じる
    }
    
    // Adobe 加工終了時
    func photoEditor(editor: AdobeUXImageEditorViewController, finishedWithImage image: UIImage?) {
        editor.dismissViewControllerAnimated(true, completion: nil) // 閉じる
        
        // 投稿画面を開く
        let postViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Post") as! PostViewController
        postViewController.image = image
        presentViewController(postViewController, animated: true, completion: nil)
    }
    // Adobe 加工キャンセル時
    func photoEditorCanceled(editor: AdobeUXImageEditorViewController) {
        editor.dismissViewControllerAnimated(true, completion: nil) // 閉じる
    }
    
}
