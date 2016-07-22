//
//  ListeningPracticeVC.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/16.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import FlexibleTableView
import SwiftyJSON
import Alamofire
import KVNProgress

class ListeningPracticeVC: UIViewController ,FlexibleTableViewDelegate,UISearchResultsUpdating {



    var tableView: FlexibleTableView!
    var searchController:UISearchController!
    
    var data:JSON = JSON("")

    @IBAction func logout(sender: AnyObject) {

        inf.logout()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = FlexibleTableView(frame:  CGRect(x: 0, y: 64, width: sWidth, height: sHeight-64-tabBarController!.tabBar.bounds.size.height), delegate: self)
        let nib = UINib(nibName: "PracticeExpandCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "PracticeExpandCell")
        self.tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clearColor()
        view.addSubview(tableView)

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        self.tableView.contentOffset = CGPoint(x: 0.0, y: searchController.searchBar.frame.size.height)

        getData()


    }

    func getData(){
        KVNProgress.showWithStatus("loading")
        inf.requestWithHeader(.GET, URLString: "/audios"){
            res in
            self.data = res
            KVNProgress.dismiss()
            self.tableView.refreshData()
            print(res)
        }
        
    }


    func tableView(tableView: FlexibleTableView, numberOfRowsInSection section: Int) -> Int{
        return data.dictionaryValue.count

    }
    func tableView(tableView: FlexibleTableView, numberOfSubRowsAtIndexPath indexPath: NSIndexPath) -> Int{
//        let row = indexPath.row
        return data["college"].arrayValue.count
    }
    func tableView(tableView: FlexibleTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FlexibleTableViewCell{
        let cell = FlexibleTableViewCell()
        cell.textLabel?.text = "大学"
        cell.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: 1.0)
        cell.expandable = true
        return cell
    }
    func tableView(tableView: FlexibleTableView, cellForSubRowAtIndexPath indexPath: FlexibleIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("PracticeExpandCell") as! PracticeExpandCell
        cell.title.text = data["college"][indexPath.subRow-1]["name"].stringValue
        cell.download.text = "\(data["college"][indexPath.subRow-1]["download"].intValue)"
        cell.favorite.text = "\(data["college"][indexPath.subRow-1]["favorites"].intValue)"
        return cell
    }


    func tableView(tableView: FlexibleTableView, heightForSubRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }


    func tableView(tableView: FlexibleTableView, didSelectSubRowAtIndexPath indexPath: FlexibleIndexPath){
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        let vc = getVC("selectTogo") as! ListenDataDetailViewController
        vc.listen_id = data["college"][indexPath.subRow-1]["id"].stringValue
        navigationController?.pushViewController(vc, animated: true)

//        tableView.deselectRowAtIndexPath(indexPath., animated: true)
    }




    func updateSearchResultsForSearchController(searchController: UISearchController){

    }



}

