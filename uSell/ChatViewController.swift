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

class ChatViewController: JSQMessagesViewController, UICollectionViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var chats:[PFObject]? = []
    var chatRoom:PFObject?
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    var fetchNewChatsTimer: NSTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.collectionView.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.senderId = PFUser.currentUser()?.username
        self.senderDisplayName = PFUser.currentUser()?.username
        self.fetchNewChatsTimer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: Selector("getNewChats"), userInfo: nil, repeats: true)
//        chatsQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//            if error == nil {
//                self.chats = objects as? [PFObject]
//                println(self.chats)
//                self.collectionView.reloadData()
//            }
//        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.fetchNewChatsTimer.invalidate()
    }
    

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        var data = self.chats![indexPath.row]
        var tempUser = data["sender"] as! PFUser
        var message = JSQMessage(senderId: tempUser["username"] as! String, displayName: tempUser["username"] as! String, text: data["text"] as! String)
        return message
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var data = self.chats![indexPath.row]
        if (PFUser.currentUser()!.isEqual(data["sender"])) {

            return self.outgoingBubble
        } else {

            return self.incomingBubble
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
            var newChat = PFObject(className: "chat")
            newChat.setObject(text, forKey: "text")
            var user = PFUser.query()?.whereKey("username", equalTo: senderId).getFirstObject()
            newChat.setObject(user!, forKey: "sender")
            newChat.setObject(self.chatRoom!, forKey: "chatRoom")
            self.chats!.append(newChat)
            newChat.saveInBackground()
            self.finishSendingMessage()
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internect, please check your connection and try again.", view: self)
        }
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
    }
    
    func getNewChats() {
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            var chatsQuery = PFQuery(className: "chat").whereKey("chatRoom", equalTo: self.chatRoom!).orderByAscending("createdAt")
            chatsQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    if let newChats = objects as? [PFObject] {
                        self.chats = newChats
                        self.collectionView.reloadData()
                    }
                }
            })
        }
    }
    
    func loadChatRoom() {
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            var chatsQuery = PFQuery(className: "chat").whereKey("chatRoom", equalTo: self.chatRoom!).orderByAscending("createdAt")
            self.chats = chatsQuery.findObjects() as? [PFObject]
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internect, please check your connection and try again.", view: self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
