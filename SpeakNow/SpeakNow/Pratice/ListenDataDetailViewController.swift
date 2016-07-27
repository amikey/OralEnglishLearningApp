//
//  ListenDataDetailViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/26.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListenDataDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var listen_id:String!

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        print(listen_id)
        customNav()
        getdata()

    }

    var data:JSON = ""

    func getdata(){
        inf.requestWithHeader(.GET, URLString: "/audiocates/"+listen_id){
            res in
            self.data = res
            print(res)
            self.tableview.reloadData()

        }
    }

    override func viewWillAppear(animated: Bool) {

    }
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage=nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func customNav(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.data["data"].arrayValue.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("listencell")!
        let row = indexPath.row

        let title = cell.viewWithTag(1) as! UILabel

        title.text = data["data"][row]["name"].stringValue
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let button = sender
        print(button)
        print(button?.superview)
        let cell = button!.superview!!.superview?.superview as! UITableViewCell
        let row = tableview.indexPathForCell(cell)!.row
        let dis = segue.destinationViewController as! ListeningViewController
        dis.url = data["data"][row]["path"].stringValue


    }

}
