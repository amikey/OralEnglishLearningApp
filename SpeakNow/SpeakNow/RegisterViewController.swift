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
    }
}
