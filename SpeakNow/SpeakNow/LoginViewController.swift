//
//  ViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/15.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import TextFieldEffects


class LoginViewController: UIViewController {

    @IBOutlet weak var userLabel: HoshiTextField!
    @IBOutlet weak var passwdLabel: HoshiTextField!
    @IBOutlet weak var Button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginTap(sender: AnyObject) {

    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userLabel.resignFirstResponder()
        passwdLabel.resignFirstResponder()
    }

}

