//
//  Extensions.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/16.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher


func getVC(x:String)->UIViewController{
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let VC = storyboard.instantiateViewControllerWithIdentifier(x)
    return VC
}

extension String{
    func isEmail()->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
}

extension UIView{
    func setRound(){
        dispatch_async(dispatch_get_main_queue()) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, self.frame.width)
            self.layer.cornerRadius = self.layer.frame.width/2
            if self.isKindOfClass(UIImageView){self.clipsToBounds = true}
        }
    }
}

extension UIImageView{
    func addPicFromUrl(x:String){
        if (x.hasPrefix("http")){self.kf_setImageWithURL(NSURL(string:x)!);return}
        print(NSURL(string:"http://tx.razord.top/\(x)"))
        self.kf_setImageWithURL(NSURL(string:"http://tx.razord.top\(x)")!)
    }
}


extension NSDate{
    func toString(format:String = "yyyy-MM-dd hh:mm") -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}


