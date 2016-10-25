//
//  MessagerViewController.swift
//  SpeakNow
//
//  Created by 称一称 on 16/8/4.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import JSQMessagesViewController
import UIKit
import Foundation
import AVOSCloud
import AVOSCloudIM
import KVNProgress
import Kingfisher

class MessagerViewController: JSQMessagesViewController, AVIMClientDelegate,VoiceInputViewDelegate {

    @IBOutlet var hud: UIView!
    
    var toid:String!
    var toname:String!
    var client:AVIMClient!
    var conversation:AVIMConversation!

    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!

    var myAvatar = UIImageView()
    
    var messages = [JSQMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 35, height: 35)
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 35, height: 35)
        initConversation()
        
        self.collectionView.backgroundView = UIImageView(image: UIImage(named: "main_bg"))

        
        self.title = "Talking With \(senderDisplayName)"
        
        prepare_audio()
        hud.removeFromSuperview()
        
        myAvatar.addPicFromUrl("http://7xq7zd.com1.z0.glb.clouddn.com/" + inf.avatar)
    }


    
    func prepare_audio(){
        let recordSettings = [AVSampleRateKey : NSNumber(float: Float(16000.0)),//声音采样率
            AVFormatIDKey : NSNumber(int: Int32(kAudioFormatLinearPCM)),//编码格式
            AVNumberOfChannelsKey : NSNumber(int: 1),//采集音轨
            AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]//音频质量

        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("Tosend.wav")//将音频文件名称追加在可用路径上形成音频文件的保存路径


        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: soundURL!,
                                                settings: recordSettings)//初始化实例

            audioRecorder.prepareToRecord()//准备录音
        } catch {
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func initConversation(){
        self.client = AVIMClient(clientId: senderId)
        self.client.openWithCallback { (success, error) in

            self.client.createConversationWithName(self.toname, clientIds: [self.toid], attributes: [:], options: AVIMConversationOption.Unique, callback: { (conversion, error) in
                self.conversation = conversion
            })

        }
            self.client.delegate = self
    }


    func sendTextNessage(string:String){
        let message = AVIMTextMessage(text: string, attributes: [:])
        self.conversation.sendMessage(message, callback: { (success, error) in
            print("\(string):发送成功")
        })
    }

    func sendAudioNessage(data:NSData){
        let file = AVFile(data: data)
        let message = AVIMAudioMessage(text: "", file: file, attributes: [:])
        self.conversation.sendMessage(message, callback: { (success, error) in
            print("音频信息:发送成功")
        })
    }





    func conversation(conversation: AVIMConversation, didReceiveTypedMessage message: AVIMTypedMessage) {
        let msg:JSQMessage
        switch message.mediaType {
        case -3:
            let audioItem = JSQAudioMediaItem(data: NSData(contentsOfURL: NSURL(string: message.file!.url!)! ))
            msg = JSQMessage(senderId: toid, displayName: toname, media: audioItem)
        case -1:
            msg = JSQMessage(senderId: toid, displayName: toname, text: message.text)
        default:
            print(message.mediaType)
            return
        }


        scrollToBottomAnimated(true)
        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
        messages.append(msg)
        finishReceivingMessageAnimated(true)


    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath:indexPath) as! JSQMessagesCollectionViewCell

        let msg = messages[indexPath.item]

        if (!msg.isMediaMessage) {
            if (msg.senderId == self.senderId) {
                cell.textView!.textColor = UIColor.blackColor()
            } else {
                cell.textView!.textColor = UIColor.whiteColor()
            }
            cell.textView!.linkTextAttributes = [ NSForegroundColorAttributeName : cell.textView!.textColor as! AnyObject,
                                                  NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue | NSUnderlineStyle.PatternSolid.rawValue ]
        }

        cell.avatarImageView.setRound()
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        self.inputToolbar.contentView.textView.resignFirstResponder()
    }
    
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!{
        let img = JSQMessagesAvatarImage(avatarImage: myAvatar.image, highlightedImage: myAvatar.image, placeholderImage: myAvatar.image)
        return img
    }

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
//        JSQSystemSoundPlayer.jsq_playMessageSentSound()

        let message = JSQMessage(senderId:senderId, senderDisplayName:senderDisplayName, date:date, text:text)
        messages.append(message)

        sendTextNessage(text)

        finishSendingMessageAnimated(true)

    }



    //气泡样式
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]

        let bubbleFactory = JSQMessagesBubbleImageFactory()

        if (message.senderId == self.senderId) {
            return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.whiteColor())
        }

        return bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString!{
        return NSAttributedString(string: "1232312")
    }




    func start_record(){
        if !audioRecorder.recording {//判断是否正在录音状态
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
                print("record!")
            } catch {
            }
        }


    }

    func end_record(){
        print("end record")

        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            print("stop!!")
        } catch {
        }

        let audio = NSData(contentsOfURL: audioRecorder.url )

        let audioItem = JSQAudioMediaItem(data: audio)
        let msg = JSQMessage(senderId: senderId, displayName: senderDisplayName, media: audioItem)
        messages.append(msg)
        sendAudioNessage(audio!)
        finishSendingMessage()
    }

    func cancle_record(){
        print("cancle_record")
        audioRecorder.stop()
        KVNProgress.showErrorWithStatus("取消发送")
    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.inputToolbar.hidden = false
        inputToolbar.contentView.textView.becomeFirstResponder()

    }


    override func didPressAccessoryButton(sender: UIButton!) {
        print(inputToolbar.contentView.textView.inputView)
        if(inputToolbar.contentView.textView.inputView == nil){
            let voice = VoiceInputViewController()
            voice.delegate = self
            addChildViewController(voice)
            inputToolbar.contentView.textView.inputView = voice.view
            inputToolbar.contentView.textView.resignFirstResponder()
            inputToolbar.contentView.textView.becomeFirstResponder()

            
        }else{
            inputToolbar.contentView.textView.inputView = nil
            inputToolbar.contentView.textView.resignFirstResponder()
            inputToolbar.contentView.textView.becomeFirstResponder()


        }
    }
    
    
    func voiceRecordDidBeagn(){
        if !view.subviews.contains(hud){
            view.addSubview(hud)
        }
        start_record()
    }
    func voiceRecordDidEnd(){
        if view.subviews.contains(hud){
            hud.removeFromSuperview()
        }
        end_record()

    }
    func voiceRecordDidCancel(){
        if view.subviews.contains(hud){
            hud.removeFromSuperview()
        }
        cancle_record()

    }

}
