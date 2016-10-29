//
//  ChatHistoryViewController.swift
//  SpeakNow
//
//  Created by CYC on 2016/10/29.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit

class ChatHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableview: UITableView!

    var data:[[String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let x = NSUserDefaults.standardUserDefaults()
        if let xx = x.objectForKey("chatHistory") as? [[String]]{
            self.data = xx
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        let row = indexPath.row
        cell.textLabel?.text = data[row][0]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let toid = data[row][1]
        let name = data[row][0]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let alert = UIAlertController(title: "进行交流？", message: "立刻与\(name)开始交流", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Go!", style: .Default, handler: { (_) in
            let vc = getVC("MessagerViewController")  as! MessagerViewController
            vc.senderId = inf.username
            vc.senderDisplayName = inf.nickname
            vc.toid = toid
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    

}
