//
//  ListenDataDetailViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/26.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListenDataDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {

    var listen_id:String!

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        print(listen_id)
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        如果遇到崩溃把这句话放到delloc里去
        navigationController?.interactivePopGestureRecognizer?.delegate = nil


    }

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
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
