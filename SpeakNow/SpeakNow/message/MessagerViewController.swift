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


class MessagerViewController: JSQMessagesViewController, AVIMClientDelegate {

    var toid:String!
    var toname:String!
    var client:AVIMClient!
    var conversation:AVIMConversation!

    var messages = [JSQMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()


        messages.append(JSQMessage(senderId: "system", displayName: "系统通知", text: "欢迎来到SpeakNow Time！"))
        self.navigationController?.title = toname
//        let audioItem = JSQAudioMediaItem(data: NSData())
//        let audioMessage = JSQMessage(senderId: "cxy", displayName: "test", media: audioItem)


        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        initConversation()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.client.conversationForId(conversation.conversationId)
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



    func recivemessage(){

    }

    func conversation(conversation: AVIMConversation!, didReceiveTypedMessage message: AVIMTypedMessage!) {
        let msg:JSQMessage
        switch message.mediaType {
        case -3:
            let audioItem = JSQAudioMediaItem(data: NSData(contentsOfURL: NSURL(string: message.file.url)! ))
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

        return cell
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
            return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        }

        return bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }

    override func didPressAccessoryButton(sender: UIButton!) {

    }

}
