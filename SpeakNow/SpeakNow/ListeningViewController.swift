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
    
    // @IBOutlet var speedbutton: UIBarButtonItem!

    @IBOutlet weak var plaubotton: UIButton!
    var id:String!
    var player:AVPlayer = AVPlayer()
    var timer:NSTimer?
    var lyric:[JSON]=[]
    var length:Double = 0
    var temptime:Int = 0
    var currentselect:Int = 0
    
    var systouch:Bool = false
    
    var tapline:Int = 0
    var tapped:Int = 0
    
    var highlightrow:Int = 0
    
    
    var speedbutton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.estimatedRowHeight = 200;
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        self.tableview.separatorStyle = .None
        self.silder.continuous = false
        
        self.speedbutton = UIBarButtonItem(title: "常速", style: .Plain, target: self, action:#selector(ListeningViewController.speedButtonTap(_:)))
        self.navigationItem.rightBarButtonItem = self.speedbutton
        
        getdata()
        
        let session = AVAudioSession.sharedInstance()
        
        do{
        try session.setCategory(AVAudioSessionCategoryPlayback)
        try session.overrideOutputAudioPort(AVAudioSessionPortOverride.None)
        try session.setActive(true)
        }catch{
        }
        
        
        plaubotton.setBackgroundImage(nil, forState: .Normal)
        plaubotton.setImage(UIImage(named: "play"), forState: .Normal)
        
        
       // plaubotton.setImage(#imageLiteral(resourceName: "play"), forState: .Normal)
        
        //plaubotton.setImage(UIImage(named: #imageLiteral(resourceName: "play")), forState: .Normal)
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stop()
    }

    func start(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ListeningViewController.update), userInfo: nil, repeats: true)
        timer?.fire()
        player.play()

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
            let path0 = res["path"].stringValue
            let path = NSURL(string: "http://7xq7zd.com1.z0.glb.clouddn.com/"+path0)!
            print(path)
            self.player = AVPlayer(URL: path)
            self.tableview.reloadData()
            self.selectRow(0)
            self.length = CMTimeGetSeconds(self.player.currentItem!.asset.duration)


        }
    }

    func update(){
            let current = CMTimeGetSeconds(player.currentTime())
            let progress = Float(current)/Float(length)
            if self.lyric.count>2 && Int(current) > lyric[temptime][0].intValue{
                selectRow(temptime)
                if temptime < lyric.count-1{
                    temptime += 1
                }
        }
        self.silder.value = progress
    }

    func selectRow(row:Int){
        if row > lyric.count-2 {return}
        print(row)
        let indexpath = NSIndexPath(forRow: row, inSection: 0)
        systouch = true
        self.highlightrow = row
        tableview.selectRowAtIndexPath(indexpath, animated: true, scrollPosition: .Top)
        tableview.reloadData()
        systouch = false
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let text = cell.viewWithTag(1) as! UILabel
        if indexPath.row == self.highlightrow{
            text.font = UIFont.boldSystemFontOfSize(14.0)
        }else{
            text.font = UIFont.systemFontOfSize(14.0)
        }
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



    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tapline == indexPath.row{
            tapped += 1
            if tapped>=2 {
                print("move to here");
                let seconds = self.lyric[indexPath.row][0].intValue
                if seconds < 0{return}
                player.seekToTime(CMTime(seconds: Double(seconds), preferredTimescale: CMTimeScale(1)))
                self.selectRow(indexPath.row)
                temptime = indexPath.row
                tapped = 0
            }
            
        }else{
            tapline = indexPath.row
            tapped = 1
        }

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
            self.plaubotton.setImage(UIImage(named: "play"), forState: .Normal)
        }else{
            start()
            self.plaubotton.setImage(UIImage(named: "stop"), forState: .Normal)
        }
    }
    
}
