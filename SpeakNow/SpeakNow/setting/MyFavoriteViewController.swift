//
//  MyFavoriteViewController.swift
//  SpeakNow
//
//  Created by CYC on 2016/10/29.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import Alamofire
import KVNProgress
import SwiftyJSON

class MyFavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var tableview: UITableView!
    var data:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        KVNProgres.sho
        request(.GET,api+"favoritelist").responseJSON{
            s in guard let ss = s.result.value else{return}
            let res = JSON(ss)
            self.data = res["favorites"].arrayValue
            print(self.data)
            self.tableview.reloadData()
            KVNProgress.dismiss()
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let row = indexPath.row
        let cell = UITableViewCell()
        cell.textLabel?.text = data[row]["name"].stringValue
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        let vc = getVC("selectTogo") as! ListenDataDetailViewController
        vc.isoral = data[row]["isoral"].boolValue
        vc.lis
    }
}
