//
//  SettingViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/7/26.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import Foundation

class SettingViewController: UITableViewController {
    @IBOutlet weak var avastar: UIImageView!


    override func viewDidLoad() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = false
navigationController?.navigationBar.barTintColor = UIColor(red: 246.0/255, green: 88.0/255, blue: 64.0/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        print(inf.avatar)

        self.avastar.addPicFromUrl(inf.avatar)

    }
}
