//
//  ListeningPracticeVC.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/16.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import FlexibleTableView

class ListeningPracticeVC: UIViewController ,FlexibleTableViewDelegate {



    var tableView: FlexibleTableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = FlexibleTableView(frame:  CGRect(x: 0, y: 64, width: sWidth, height: sHeight-64-tabBarController!.tabBar.bounds.size.height), delegate: self)
        let nib = UINib(nibName: "PracticeExpandCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "PracticeExpandCell")
        self.tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }



    func tableView(tableView: FlexibleTableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    func tableView(tableView: FlexibleTableView, numberOfSubRowsAtIndexPath indexPath: NSIndexPath) -> Int{
        return 6
    }
    func tableView(tableView: FlexibleTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FlexibleTableViewCell{
        let cell = FlexibleTableViewCell()
        cell.textLabel?.text = "2019年全国1卷"
        cell.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: 1.0)
        cell.expandable = true
        return cell
    }
    func tableView(tableView: FlexibleTableView, cellForSubRowAtIndexPath indexPath: FlexibleIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("PracticeExpandCell") as! PracticeExpandCell
        return cell
    }
    func tableView(tableView: FlexibleTableView, heightForSubRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }


}

