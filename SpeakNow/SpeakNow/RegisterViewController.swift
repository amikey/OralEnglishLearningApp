//
//  RegisterViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/15.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import Material
import Alamofire
import KVNProgress

class RegisterViewController: UIViewController {

    @IBOutlet weak var username: TextField!
    @IBOutlet weak var pwd: TextField!
    @IBOutlet weak var doubleped: TextField!
    @IBOutlet weak var nickname: TextField!
    @IBOutlet weak var mail: TextField!
    @IBOutlet weak var Button: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        username.resignFirstResponder()
        pwd.resignFirstResponder()
        doubleped.resignFirstResponder()
        nickname.resignFirstResponder()
        nickname.resignFirstResponder()
        mail.resignFirstResponder()
        down()
    }

    @IBAction func up(sender: AnyObject) {
        let dis = sHeight - Button.frame.origin.y-Button.frame.size.height-216.0-10
        if dis<0.0{
            UIView.animateWithDuration(0.3){
                self.view.frame=CGRect(x: 0,y: dis,width: sWidth,height: sHeight)
            }
        }
    }

    func down() {
        UIView.animateWithDuration(0.3){
            self.view.frame=CGRect(x: 0,y: 0,width: sWidth,height: sHeight)
        }
    }

    @IBAction func buttonTap(sender: AnyObject) {
        let data = ["username":username.text!,
                    "password":pwd.text!,
                    "nickname":nickname.text!,
                    "email":mail.text!
                    ]
        let req = NSMutableURLRequest(URL: NSURL(string: "http://115.28.241.122/api/register")!)
        req.HTTPMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        req.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(data, options: [])

        KVNProgress.showWithStatus("请稍后")

        request(req).responseJSON(){
            s in guard let res = s.result.value else{return}
            if res["message"]as!String == "注册成功"{
                inf.reflashHeader(res["token"]as!String)
                self.presentViewController(getVC("mainTabVC"), animated: true, completion: nil)
            }else{
                KVNProgress.showErrorWithStatus(res["message"]as!String)
                print(res["message"]as!String)
            }

        }
    }



}
