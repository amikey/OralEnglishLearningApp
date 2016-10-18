//
//  VoiceInputViewController.swift
//  SpeakNow
//
//  Created by CYC on 2016/10/18.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit


protocol VoiceInputViewDelegate {
    func voiceRecordDidBeagn()
    func voiceRecordDidEnd()
    func voiceRecordDidCancel()
}


class VoiceInputViewController: UIViewController ,UIGestureRecognizerDelegate{
    
    var delegate:VoiceInputViewDelegate? = nil
    var isRecoarding:Bool = false
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let long = UILongPressGestureRecognizer(target: self, action: #selector(VoiceInputViewController.long_gesture(_:)))
        long.delegate = self
        button.addGestureRecognizer(long)
        
        let swip_up = UIPanGestureRecognizer(target: self, action: #selector(VoiceInputViewController.swipDidBegain(_:)))
        swip_up.delegate = self
        button.addGestureRecognizer(swip_up)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func long_gesture(gesture:UILongPressGestureRecognizer){
        switch gesture.state {
        case .Began:
            isRecoarding = true
            delegate?.voiceRecordDidBeagn()
        case .Ended:
            isRecoarding = false
            if isRecoarding{
                delegate?.voiceRecordDidEnd()
            }
        default:
            break
        }
    }
    
    func swipDidBegain(gesture:UIPanGestureRecognizer){
        if(gesture.translationInView(gesture.view).y < -50 && isRecoarding){
            isRecoarding = false
            delegate?.voiceRecordDidCancel()
        }
        
    }
}
