//
//  ScoreDetailViewController.swift
//  SpeakNow
//
//  Created by CYC on 2016/10/27.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit

class ScoreDetailViewController: UIViewController {

    @IBOutlet var textview: UITextView!
    
    var text:String! = nil
    
    func set_text(s:String){self.text = s}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textview.text = text
        // Do any additional setup after loading the view.
    }


    override func viewDidAppear(animated: Bool) {
        self.textview.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
