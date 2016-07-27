//
//  ListeningViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/7/15.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import AVFoundation

class ListeningViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,AVAudioSessionDelegate {

    @IBOutlet weak var tableview: UITableView!

    @IBOutlet weak var silder: UISlider!

    var url:String!
    var player:AVPlayer = AVPlayer()
    var timer:NSTimer?


    override func viewDidLoad() {
        super.viewDidLoad()
//        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ListeningViewController.update), userInfo: nil, repeats: true)
//        timer?.fire()
//        player.delegate = self
//        player.dele
        let path = NSURL(string: "http://tx.razord.top"+url)!
//        let soundData = NSData(contentsOfURL:path)!
        print(path)
        player = AVPlayer(URL: path)
        player.play()



    }

    func update(){
        let current = player.currentTime
//        let total = player.
//        let progress = Float((current/total))
//        self.silder.value = progress

//        let indexpath = NSIndexPath(forRow: 0, inSection: 0)

//        tableview.selectRowAtIndexPath(indexpath, animated: true, scrollPosition: .Middle)
    }




    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        return cell
    }

    @IBAction func silder_move(sender: AnyObject) {
    }
}
