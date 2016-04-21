//
//  ViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/15.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import KVNProgress


class LoginViewController: UIViewController {

    @IBOutlet weak var userLabel: UITextField!
    @IBOutlet weak var passwdLabel: UITextField!
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
//        KVNProgress.showWithStatus("登录中")
        inf.login(userLabel.text!,password:passwdLabel.text!){
            inf.getProfile(){
                inf.username = self.userLabel.text!
                inf.pwd = self.passwdLabel.text!
                inf.save()
//                KVNProgress.dismiss()
                (UIApplication.sharedApplication().delegate as! AppDelegate).changeRootVC(getVC("mainTabVC"))

            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userLabel.resignFirstResponder()
        passwdLabel.resignFirstResponder()
        down()
    }


    
    @IBAction func up(sender: UIView) {
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

