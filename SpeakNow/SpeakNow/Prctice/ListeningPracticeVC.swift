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
    
    @IBOutlet weak var switchbutton: UISegmentedControl!
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

        inf.login(){
            self.getData()
        }


    }

    func getData(oral:Bool=false){
        KVNProgress.showWithStatus("loading")
        print(api+"categories")
        let url:String
        if oral{
            url = api+"categories/orals"
        }else {url=api+"categories"}
        request(.GET, url).responseJSON{
            s in guard let vaule = s.result.value else{return}
            let res = JSON(vaule)
            self.data = res
            print(res)
            KVNProgress.dismiss()
            self.tableView.refreshData()
        }
        
    }

    @IBAction func switchbuttonchange(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            getData()
        }else{
            getData(true)
        }
    }

    func tableView(tableView: FlexibleTableView, numberOfRowsInSection section: Int) -> Int{
        return 4

    }
    func tableView(tableView: FlexibleTableView, numberOfSubRowsAtIndexPath indexPath: NSIndexPath) -> Int{
//        let row = indexPath.row
        return data["categories"][indexPath.row]["array"].count
    }
    func tableView(tableView: FlexibleTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FlexibleTableViewCell{
        let cell = FlexibleTableViewCell()
        cell.textLabel?.text = data["categories"][indexPath.row]["name"].stringValue
        cell.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: 1.0)
        cell.expandable = true
        return cell
    }
    func tableView(tableView: FlexibleTableView, cellForSubRowAtIndexPath indexPath: FlexibleIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("PracticeExpandCell") as! PracticeExpandCell
        cell.title.text = data["categories"][indexPath.row]["array"][indexPath.subRow-1]["catename"].stringValue
        cell.backgroundColor = UIColor.clearColor()

        cell.download.text = "\(data["categories"][indexPath.row]["array"][indexPath.subRow-1]["download"].intValue)"
        cell.favorite.text = "\(data["categories"][indexPath.row]["array"][indexPath.subRow-1]["favorite"].intValue)"
        return cell
    }

    func tableView(tableView: FlexibleTableView, heightForSubRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100.0
    }

    func tableView(tableView: FlexibleTableView, shouldExpandSubRowsOfCellAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 0{return true}
        return false
    }


    func tableView(tableView: FlexibleTableView, didSelectSubRowAtIndexPath indexPath: FlexibleIndexPath){
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        navigationItem.backBarButtonItem = backItem
        let vc = getVC("selectTogo") as! ListenDataDetailViewController
        vc.listen_id = data["categories"][indexPath.row]["array"][indexPath.subRow-1]["id"].stringValue
        if switchbutton.selectedSegmentIndex == 0{
            vc.isoral = false
        }else{vc.isoral=true}
        navigationController?.pushViewController(vc, animated: true)

//        tableView.deselectRowAtIndexPath(indexPath., animated: true)
    }




    func updateSearchResultsForSearchController(searchController: UISearchController){

    }



}

