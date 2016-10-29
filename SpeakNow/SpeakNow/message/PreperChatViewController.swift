//
//  PreperChatViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/8/4.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import AudioToolbox
import Alamofire
import SwiftyJSON

class PreperChatViewController: UIViewController {

    @IBOutlet weak var to: UITextField!
    
    var user_id:String? = nil
    var req:Request?
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().applicationSupportsShakeToEdit = true
        becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        request(.PUT, "https://learning2learn.cn/speaknow/chat/userstatus")
    }
    
    override func viewDidDisappear(animated: Bool) {
        UIApplication.sharedApplication().applicationSupportsShakeToEdit = false
        request(.DELETE, "https://learning2learn.cn/speaknow/chat/userstatus")

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        to.resignFirstResponder()
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("开始摇动")
        self.user_id = nil
        self.req = request(.POST, "https://learning2learn.cn/speaknow/chat/getuser").responseJSON{
            s in
            guard let ss = s.result.value else{return}
            let res = JSON(ss)
            print(res)
            if res["success"].boolValue{
                self.user_id = res["user"].stringValue
                print("可匹配id:\(self.user_id)")
            }
        }

    }
    
    override func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent?) {
//        self.user_id = nil
//        req?.cancel()
        print("取消摇动")
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("摇动停止")
//        req?.cancel()
        
        let toid:String
        
        if self.user_id != nil && self.user_id! != inf.uid{
            toid = self.user_id!
        }else{toid = to.text!}
        
        if toid == ""{return}
        
        
        let vc = getVC("MessagerViewController")  as! MessagerViewController
        vc.senderId = inf.uid
        vc.senderDisplayName = inf.nickname
        vc.toid = toid
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

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
