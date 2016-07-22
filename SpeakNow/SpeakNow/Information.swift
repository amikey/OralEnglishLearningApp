//
//  Information.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/16.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import KeychainSwift
import KVNProgress
import SwiftyJSON


let inf=Information()

let sWidth = UIScreen.mainScreen().bounds.width
let sHeight = UIScreen.mainScreen().bounds.height

class Information:NSObject{

    let keychain = KeychainSwift()

    override init() {
        if let x = keychain.get("username"){username = x}
        if let x = keychain.get("password"){pwd = x}
    }

    var username = ""
    var pwd = ""
    var avatar = ""
    var headers = ["Authorization": ""]
    var uid:String = ""
    var email:String = ""
    var nickname:String = ""

    func reflashHeader(token:String){
        print(token)
        self.headers = ["Authorization": "Bearer \(token)"]
    }


    func login(completionHandler:(()->())?=nil){
        login(username, password: pwd, completionHandler: completionHandler)
    }


    func login(username:String,password:String,completionHandler:(()->())?=nil) {
        let data = ["username":username,"password":password,]
        let req = NSMutableURLRequest(URL: NSURL(string: "http://tx.razord.top/api/login")!)
        req.HTTPMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(data, options: [])

        request(req).responseJSON{
            s in guard let res = s.result.value else{return}
            if(s.response?.statusCode == 400){
                KVNProgress.showErrorWithStatus(res["message"]as!String)
                return
            }
            self.avatar = res["avatar"] as! String
            self.reflashHeader(res["token"] as! String)
            completionHandler?()
        }
    }

    func getProfile(completionHandler:(()->())?=nil){
        request(.GET, "http://tx.razord.top/api/profile",headers: headers).responseJSON{
            s in guard let res = s.result.value else{return}
            self.uid = res["id"]as!String
            self.email = res["email"]as!String
            self.nickname = res["nickname"]as!String
            completionHandler?()
        }
    }

    func logout(){
        keychain.clear()
        (UIApplication.sharedApplication().delegate as! AppDelegate).changeRootVC(getVC("LoginNav"))
    
    }

    func save(){
        keychain.set(username, forKey: "username")
        keychain.set(pwd, forKey: "password")
    }
    
    
    func requestWithHeader(method: Alamofire.Method, URLString: String, parameters: [String : AnyObject]?=nil,handler:((JSON)->())? = nil ) {
        let url = "http://tx.razord.top/api"+URLString
        print(url)
        request(method, url,headers: headers,parameters:parameters).responseJSON{
            s in guard let res = s.result.value else{KVNProgress.showError();return}
            if s.response?.statusCode == 401{
                self.login(){
                    self.requestWithHeader(method, URLString: URLString,parameters: parameters,handler: handler)
                }
                return
            }
            let s = JSON(res)
            handler?(s)
        }
    }

}


