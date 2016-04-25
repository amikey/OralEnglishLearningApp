//
//  Extensions.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/16.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import Foundation

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
