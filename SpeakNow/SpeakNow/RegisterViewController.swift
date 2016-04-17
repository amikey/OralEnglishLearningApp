//
//  RegisterViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/15.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import TextFieldEffects


class RegisterViewController: UIViewController {

    @IBOutlet weak var username: HoshiTextField!
    @IBOutlet weak var pwd: HoshiTextField!
    @IBOutlet weak var doubleped: HoshiTextField!
    @IBOutlet weak var nickname: HoshiTextField!
    @IBOutlet weak var mail: HoshiTextField!
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


}
