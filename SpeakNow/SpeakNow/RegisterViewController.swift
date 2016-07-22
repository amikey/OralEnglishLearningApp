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

class RegisterViewController: UIViewController ,TextFieldDelegate{

    @IBOutlet weak var username: TextField!
    @IBOutlet weak var pwd: TextField!
    @IBOutlet weak var doubleped: TextField!
    @IBOutlet weak var nickname: TextField!
    @IBOutlet weak var mail: TextField!
    @IBOutlet weak var Button: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setErrorNotice()
    }

    func setErrorNotice(){
        username.set_detailLabel("用户名长度不得少于3位")
        pwd.set_detailLabel("密码不得少于6位")
        doubleped.set_detailLabel("两次密码输入不一致")
        nickname.set_detailLabel("昵称不合法")
        mail.set_detailLabel("邮箱不合法")

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
        let req = NSMutableURLRequest(URL: NSURL(string: "http://tx.razord.top/api/register")!)
        req.HTTPMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        req.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(data, options: [])

        KVNProgress.showWithStatus("请稍后")

        request(req).responseJSON(){
            s in guard let res = s.result.value else{KVNProgress.showError();return}
            print(res)
            if res["message"]as!String == "注册成功"{
                inf.reflashHeader(res["token"]as!String)
                KVNProgress.dismiss()
                (UIApplication.sharedApplication().delegate as!AppDelegate).changeRootVC(getVC("mainTabVC"))
            }else{
                KVNProgress.showErrorWithStatus(res["message"]as!String)
                print(res["message"]as!String)
            }

        }
    }

    @IBAction func textfieldVauleChange(sender: AnyObject) {
        (sender as! TextField).detailLabelHidden = check(sender as! UITextField)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let res = check(textField)
        (textField as! TextField).detailLabelHidden = res
        if res{
            switch textField.tag {
            case 1:pwd.becomeFirstResponder()
            case 2:doubleped.becomeFirstResponder()
            case 3:nickname.becomeFirstResponder()
            case 4:mail.becomeFirstResponder()
            default:break
            }
        }
        return true
    }



    func check(textField: UITextField)->Bool{
        switch textField.tag {
        case 1:
            return textField.text?.characters.count > 3
        case 2:
            return textField.text?.characters.count >= 6
        case 3:
            return textField.text == pwd.text
        case 4:
            return textField.text?.characters.count > 3
        case 5:
            return (textField.text?.isEmail())!
        default:
            return false
        }
    }


}


extension TextField{
    func set_detailLabel(x:String){
        self.detailLabel.text = x
        self.detailLabelActiveColor = MaterialColor.red.accent3
        self.detailLabel.font = RobotoFont.regularWithSize(10)
        self.detailLabelAutoHideEnabled = false
    }
}
