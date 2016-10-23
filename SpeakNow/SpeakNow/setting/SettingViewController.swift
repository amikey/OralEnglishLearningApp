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

    @IBOutlet var nickname: UITextField!
    @IBOutlet var mail: UITextField!

    override func viewDidLoad() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 246.0/255, green: 88.0/255, blue: 64.0/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.avastar.addPicFromUrl("http://7xq7zd.com1.z0.glb.clouddn.com/" + inf.avatar)
        self.avastar.setRound()
        self.nickname.text = inf.nickname
        self.mail.text = inf.email
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.textColor = UIColor.grayColor()
    }



}
