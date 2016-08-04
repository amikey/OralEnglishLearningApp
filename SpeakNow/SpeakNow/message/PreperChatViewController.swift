//
//  PreperChatViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/8/4.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit

class PreperChatViewController: UIViewController {

    @IBOutlet weak var to: UITextField!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! MessagerViewController
        vc.senderId = inf.username
        vc.senderDisplayName = inf.nickname
        vc.toid = to.text!
        vc.toname = to.text!
    }
}
