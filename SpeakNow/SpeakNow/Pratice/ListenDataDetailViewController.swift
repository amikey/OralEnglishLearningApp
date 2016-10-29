//
//  ListenDataDetailViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/26.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ListenDataDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {

    var listen_id:String!
    var isoral:Bool!

    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet var updateTime: UILabel!
    @IBOutlet var download: UILabel!
    @IBOutlet var favorited: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var introduce: UITextView!
    @IBOutlet var leftimage: UIImageView!
    @IBOutlet var favoirteButton: UIButton!
    
    var data:JSON = ""

    var isfavorited:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        print(listen_id)
        getdata()
        
        let data = NSUserDefaults.standardUserDefaults()
        
        if let x = data.objectForKey(listen_id) as? [String]{
            self.progressLabel.text = x[0]
        }else{
            self.progressLabel.text = "还未开始学习"
            self.continueButton.hidden = true
        }
        
        
        getfavorite()

    }

    func getfavorite(){
        request(.GET,api+"categories/\(listen_id)/favorite").responseJSON{
            s in guard let vaule = s.result.value else{return}
            let res = JSON(vaule)
            self.isfavorited = res["favorite"].boolValue
            if self.isfavorited{
                self.favoirteButton.setImage(UIImage(named: "star-house2"), forState: .Normal)
            }else{
                self.favoirteButton.setImage(UIImage(named: "star-house"), forState: .Normal)
            }
        }
    }
    

    @IBAction func continueTap(sender: AnyObject) {
        let data = NSUserDefaults.standardUserDefaults()

        guard let x = data.objectForKey(listen_id) as? [String]else{return}
        
        if isoral==true {
            let vc = getVC("oral") as! OralTestingViewController
            vc.audioid = x[1]
            vc.title = x[0]
            navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc = getVC("listen")as! ListeningViewController
            vc.id = x[1]
            vc.title = x[0]
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @IBAction func favoriteTap(sender: AnyObject) {
        print(self.isfavorited)
        if self.isfavorited{
            request(.DELETE, api+"categories/\(listen_id)/favorite")
            self.favoirteButton.setImage(UIImage(named: "star-house"), forState: .Normal)

        }else{
            request(.POST, api+"categories/\(listen_id)/favorite")
            self.favoirteButton.setImage(UIImage(named: "star-house2"), forState: .Normal)
        }
        self.isfavorited = !self.isfavorited

        
        
    }
    
    func getdata(){
        request(.GET,api+"categories/"+listen_id).responseJSON{
            s in guard let vaule = s.result.value else{return}
            let res = JSON(vaule)
            self.data = res
            print(res)
            self.favorited.text = "\(res["favorite"].intValue)"
            self.download.text = "\(res["download"].intValue)"
            self.name.text = res["name"].stringValue
            self.introduce.text = res["introduce"].stringValue
            if(res["image"].stringValue != ""){
            self.leftimage.kf_setImageWithURL(NSURL(string: "http://7xq7zd.com1.z0.glb.clouddn.com/\(res["image"].stringValue)"))
            }
            self.tableview.reloadData()
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewWillDisappear(animated: Bool) {
        
        
        //if self.navigationController?.viewControllers.indexOf(self) == nil{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            //如果遇到崩溃把这句话放到delloc里去
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
 
        //}


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
        return self.data["materials"].arrayValue.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("listencell")!
        let row = indexPath.row

        let title = cell.viewWithTag(1) as! UILabel

        title.text = data["materials"][row]["name"].stringValue
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let button = sender
        let cell = button!.superview!!.superview?.superview as! UITableViewCell
        let row = tableview.indexPathForCell(cell)!.row
        let dis = segue.destinationViewController as! ListeningViewController
        dis.id = data["materials"][row]["id"].stringValue


    }
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func playbuttonTap(sender: UIButton) {
        let view = sender.superview?.superview?.superview as! UITableViewCell
        let indexpath = tableview.indexPathForCell(view)

        let id = data["materials"][(indexpath?.row)!]["id"].stringValue
        
        let datas = NSUserDefaults.standardUserDefaults()
        datas.setObject([data["materials"][(indexpath?.row)!]["name"].stringValue,id], forKey: self.listen_id)
        
        if isoral==true {
            let vc = getVC("oral") as! OralTestingViewController
            vc.audioid = data["materials"][(indexpath?.row)!]["id"].stringValue
            vc.title = data["materials"][(indexpath?.row)!]["name"].stringValue
            navigationController?.pushViewController(vc, animated: true)

        }else{
            let vc = getVC("listen")as! ListeningViewController
            vc.id = id
            vc.title = data["materials"][(indexpath?.row)!]["name"].stringValue
            navigationController?.pushViewController(vc, animated: true)

        }

    }
}
