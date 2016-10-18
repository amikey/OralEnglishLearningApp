//
//  PreperChatViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/8/4.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import AudioToolbox

class PreperChatViewController: UIViewController {

    @IBOutlet weak var to: UITextField!
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().applicationSupportsShakeToEdit = true
        becomeFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        UIApplication.sharedApplication().applicationSupportsShakeToEdit = false
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        to.resignFirstResponder()
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("开始摇动")
        
    }
    
    override func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("取消摇动")
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("摇动停止")
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        if to.text == ""{return}
        let vc = getVC("MessagerViewController")  as! MessagerViewController
        vc.senderId = inf.username
        vc.senderDisplayName = inf.nickname
        
        vc.toid = to.text!
        vc.toname = to.text!
        
        navigationController?.pushViewController(vc, animated: true)
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier  != "chat"{return}
        let vc = segue.destinationViewController as! MessagerViewController
        vc.senderId = inf.username
        vc.senderDisplayName = inf.nickname
        vc.toid = to.text!
        vc.toname = to.text!
    }

}
