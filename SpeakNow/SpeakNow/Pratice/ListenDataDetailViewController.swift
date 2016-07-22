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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        print(listen_id)
        customNav()

    }

    var data:JSON = ""

    func getdata(){
        inf.requestWithHeader(.GET, URLString: "/audios/"+listen_id){
            res in
            self.data = res
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
        return 10
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("listencell")!
        return cell
    }

}
