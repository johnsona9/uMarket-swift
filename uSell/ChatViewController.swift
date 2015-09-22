//
//  ChatViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/11/15.
//
//

import UIKit
import Foundation
import MediaPlayer
import Parse
import JSQMessagesViewController
import JSQSystemSoundPlayer
import Reachability

protocol ChatViewControllerDelegate {
    func updateMostRecentChat(controller: ChatViewController, object: PFObject)
}

class ChatViewController: JSQMessagesViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var delegate: ChatViewControllerDelegate?
    var chats:[PFObject]? = []
    var chatRoom:PFObject!
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(GlobalConstants.Colors.buttonBackgroundColor)
    var fetchNewChatsTimer: NSTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.collectionView!.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.showLoadEarlierMessagesHeader = true
        self.senderId = PFUser.currentUser()?.username!
        self.senderDisplayName = PFUser.currentUser()?.username!
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.fetchNewChatsTimer.invalidate()
        if self.delegate != nil  && self.chats?.count > 0{
            self.delegate?.updateMostRecentChat(self, object: self.chats!.last!)
        }
    }
    

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.chats![indexPath.row]
        let tempUser = data["sender"] as! PFUser
        let message = JSQMessage(senderId: tempUser.username!, displayName: tempUser.username!, text: data["text"] as! String)
        return message
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = self.chats![indexPath.row]
        if (PFUser.currentUser()!.isEqual(data["sender"])) {

            return self.outgoingBubble
        } else {

            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            let chatIds = self.chats!.map({ ($0 as PFObject).objectId! })
            let moreChatsQuery = PFQuery(className: "chat").whereKey("objectId", notContainedIn: chatIds).orderByDescending("createdAt")
            moreChatsQuery.limit = 10
            moreChatsQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if error == nil {
                    if var moreChats = objects as? [PFObject] {
                        moreChats = moreChats.reverse()
                        self.chats = moreChats + self.chats!
                        self.collectionView!.reloadData()
                    }
                }
            }
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internet, please check your connection and try again.", view: self)
        }
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chats!.count;
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            let newChat = PFObject(className: "chat")
            newChat.setObject(text, forKey: "text")
            newChat.setObject(PFUser.currentUser()!, forKey: "sender")
            newChat.setObject(self.chatRoom!, forKey: "chatRoom")
            self.chats!.append(newChat)
            self.finishSendingMessage()
            self.chatRoom?.setObject(NSDate(), forKey: "updatedAt")
            self.chatRoom?.saveInBackground()
            newChat.saveInBackground()
            let pushQuery : PFQuery = PFInstallation.query()!
            let user1: PFUser = self.chatRoom["user1"] as! PFUser
            let user2: PFUser = self.chatRoom["user2"] as! PFUser
            if user1.username! == self.senderId {
                pushQuery.whereKey("user", equalTo: user2)
            } else {
                pushQuery.whereKey("user", equalTo: user1)
            }
            PFPush.sendPushMessageToQueryInBackground(pushQuery, withMessage: "\(self.senderId): \(text)")
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internet, please check your connection and try again.", view: self)
        }
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
    }
    
    
    
    func getNewChats() {
        if self.chatRoom != nil {
            let reachability = Reachability.reachabilityForInternetConnection()
            if (reachability.isReachable()) {
                if self.chats?.count > 0 {
                    let chatIds = self.chats!.map({ ($0 as PFObject).objectId! })
                    let mostRecentDate = self.chats?.first!.createdAt!
                    let chatsQuery = PFQuery(className: "chat").whereKey("chatRoom", equalTo: self.chatRoom!).whereKey("objectId", notContainedIn: chatIds)
                        chatsQuery.whereKey("createdAt", greaterThanOrEqualTo: mostRecentDate!).orderByAscending("createdAt")
                        chatsQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if error == nil {
                            if let newChats = objects as? [PFObject] {
                                self.chats = self.chats! + newChats
                                self.collectionView!.reloadData()
                                self.scrollToBottomAnimated(true)
                            }
                        }
                    })
                }
            }
        }
    }
    
    func loadChatRoom() {
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            self.getChatsInBackground()
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internet, please check your connection and try again.", view: self)
        }
    }
    
    private func getChatsInBackground() {
        let chatsQuery = PFQuery(className: "chat").whereKey("chatRoom", equalTo: self.chatRoom!).orderByDescending("createdAt")
        chatsQuery.limit = 20
        chatsQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                if let newChats = objects as? [PFObject] {
                    self.chats = newChats
                    self.chats = self.chats?.reverse()
                    self.collectionView!.reloadData()
                    self.fetchNewChatsTimer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: Selector("getNewChats"), userInfo: nil, repeats: true)
                    
                    self.scrollToBottomAnimated(false)
                }
            }
        })
    }

}
