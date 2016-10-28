//
//  ListeningViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/7/15.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class ListeningViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,AVAudioSessionDelegate {

    @IBOutlet weak var tableview: UITableView!

    @IBOutlet weak var silder: UISlider!
    
    @IBOutlet var speedbutton: UIBarButtonItem!

    var id:String!
    var player:AVPlayer = AVPlayer()
    var timer:NSTimer?
    var lyric:[JSON]=[]
    var length:Int = 0
    var temptime:Int = 0
    var currentselect:Int = 0
    
    var systouch:Bool = false
    
    var tapline:Int = 0
    var tapped:Int = 0

    @IBOutlet var navtitle: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.estimatedRowHeight = 200;
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        tableview.separatorStyle = .None
        getdata()
        
        let session = AVAudioSession.sharedInstance()
        
        do{
        try session.setCategory(AVAudioSessionCategoryPlayback)
        try session.overrideOutputAudioPort(AVAudioSessionPortOverride.None)
        try session.setActive(true)
        }catch{
            print("!!!!!!")
        }
        
        navtitle.title = title
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stop()
    }

    func start(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ListeningViewController.update), userInfo: nil, repeats: true)
        timer?.fire()
        player.play()

        print("playing")
    }

    func stop(){
        player.pause()
        timer?.invalidate()
        timer = nil
    }

    func getdata(){
        print(api+"audio/"+id)
        request(.GET, api+"audio/"+id).responseJSON{
            s in guard let vaule = s.result.value else{return}
            let res = JSON(vaule)
            self.lyric = res["lyric"].arrayValue
            self.length = res["length"].intValue
            let path0 = res["path"].stringValue
            let path = NSURL(string: "http://7xq7zd.com1.z0.glb.clouddn.com/"+path0)!
            print(path)
            self.player = AVPlayer(URL: path)
            self.tableview.reloadData()
            self.selectRow(0)


        }
    }

    func update(){
            let current = CMTimeGetSeconds(player.currentTime())
            let progress = Float(current)/Float(length)
            if Int(current) > lyric[temptime][0].intValue{
                selectRow(temptime)
                if temptime < lyric.count-1{temptime += 1}
        }
        self.silder.value = progress
    }

    func selectRow(row:Int){
        if row > lyric.count-2 {return}
        print(row)
        let indexpath = NSIndexPath(forRow: row, inSection: 0)
        systouch = true
        tableView(tableview, willSelectRowAtIndexPath: indexpath)
        tableview.selectRowAtIndexPath(indexpath, animated: true, scrollPosition: .Middle)
        tableView(tableview, didSelectRowAtIndexPath : indexpath)
        systouch = false
    }



    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return lyric.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("listen")!
        let label = cell.viewWithTag(1) as! UILabel
        label.text = lyric[indexPath.row][1].stringValue
        cell.selectionStyle = .None
//        cell.userInteractionEnabled = false
        return cell
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if systouch{
            if let current = tableview.indexPathForSelectedRow{
                let cell = tableview.cellForRowAtIndexPath(current)
                if let text = cell?.viewWithTag(1) as? UILabel{
                    text.textColor = UIColor.blackColor()
                }
            }
        }else{
        }
        return indexPath
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if systouch{
            if let cell = tableview.cellForRowAtIndexPath(indexPath){
                if let text = cell.viewWithTag(1) as? UILabel{
                    text.textColor = UIColor.redColor()
                }
            }
        }else{
            print("\(indexPath.row) \(tapped) \(tapline)")
            if tapline == indexPath.row{
                tapped += 1
                if tapped>=2 {
                    print("move to here");
                    let seconds = Float(indexPath.row - 1)/Float(lyric.count) * Float(length)
                    if seconds < 0{return}
                    player.seekToTime(CMTime(seconds: Double(seconds), preferredTimescale: CMTimeScale(1)))

                    tapped = 0
                }
                
            }else{
                tapline = indexPath.row
                tapped = 1
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        let seconds = silder.value * Float(length)

//        for i in 0 ..< lyric.count{
//            if Int(seconds) > lyric[i][0].intValue{
//                if indexPath.row != i{
//                    if let x = cell.viewWithTag(1) as? UILabel{x.textColor = UIColor.blackColor()}
//                    return
//                }
//            }
//        }
    }

    @IBAction func silder_move(sender: AnyObject) {
        let seconds = silder.value * Float(length)
        player.seekToTime(CMTime(seconds: Double(seconds), preferredTimescale: CMTimeScale(1)))

        for i in 0 ..< lyric.count{
            if Int(seconds) > lyric[i][0].intValue{
                selectRow(i)
                temptime = i
            }
        }
    }

    @IBAction func speedButtonTap(sender: AnyObject) {
        if player.rate == 0.0{
            return
        }
        if speedbutton.title == "常速"{
            speedbutton.title = "2X"
            player.rate = 2.0
        }else{
            speedbutton.title = "常速"
            player.rate = 1.0
        }
    }
    @IBAction func playClick(sender: AnyObject) {
        if player.rate != 0.0{
            stop()
        }else{
            start()
        }
    }
    
}
