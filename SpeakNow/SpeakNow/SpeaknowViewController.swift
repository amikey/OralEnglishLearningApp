//
//  SpeaknowViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/8/7.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit

class NoNavViewController: UIViewController,UIGestureRecognizerDelegate  {

    // hide nav
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }


}
