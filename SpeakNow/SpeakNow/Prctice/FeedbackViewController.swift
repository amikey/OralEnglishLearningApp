//
//  ViewController.swift
//  SpeakNow
//
//  Created by CYC on 2016/10/25.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import KVNProgress

class FeedbackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func butttontap(sender: AnyObject) {
        KVNProgress.showSuccessWithStatus("提交成功") { 
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
