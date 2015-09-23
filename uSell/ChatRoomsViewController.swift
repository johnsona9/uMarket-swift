//
//  ChatRoomsViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/12/15.
//
//

import UIKit
import Parse
import Reachability

class ChatRoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChatViewControllerDelegate {

    var chatRooms = [PFObject]()
    var otherUsers = [PFUser]()
    var selectedRow: NSIndexPath?
    
    @IBOutlet weak var chatRoomsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.chatRoomsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.getChatRooms()
        self.handleColors()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("chatRoomsToChatSegue", sender: indexPath)
        self.selectedRow = indexPath
        chatRoomsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        }
        
        self.otherUsers[indexPath.row].fetchIfNeededInBackgroundWithBlock { (object, error) -> Void in
            if error == nil {
                cell!.textLabel?.text = object!["username"] as? String
            }
        }
        
        
        let queryForChat: PFQuery = PFQuery(className: "chat").whereKey("chatRoom", equalTo: self.chatRooms[indexPath.row]).orderByDescending("createdAt")
        queryForChat.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if error == nil {
                if let chat = object as PFObject? {
                    cell!.detailTextLabel?.text = chat["text"] as? String
                    print(chat)
                }
            }
        }
        
        cell!.textLabel?.textColor = GlobalConstants.Colors.cellTextColor
        cell!.detailTextLabel?.textColor = GlobalConstants.Colors.cellDetailTextColor
        cell!.backgroundColor = GlobalConstants.Colors.cellBackgroundColor
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.otherUsers.count
    }
    
    func updateMostRecentChat(controller: ChatViewController, object: PFObject) {
        self.chatRoomsTableView.cellForRowAtIndexPath(self.selectedRow!)?.detailTextLabel?.text = object["text"] as? String
        self.selectedRow = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "chatRoomsToChatSegue" {
            let reachability = Reachability.reachabilityForInternetConnection()
            if (reachability.isReachable()) {
                let svc = segue.destinationViewController as? ChatViewController
                let query = PFQuery(className: "chatRoom")
                query.whereKey("user1", equalTo: PFUser.currentUser()!)
                query.whereKey("user2", equalTo: otherUsers[(sender as! NSIndexPath).row])
                let inverseQuery = PFQuery(className: "chatRoom")
                inverseQuery.whereKey("user2", equalTo: PFUser.currentUser()!)
                inverseQuery.whereKey("user1", equalTo: otherUsers[(sender as! NSIndexPath).row])
                let queryCombined = PFQuery.orQueryWithSubqueries([query, inverseQuery])
                queryCombined.includeKey("user1")
                queryCombined.includeKey("user2")
                
                queryCombined.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                    if error == nil {
                        if let testChatRoom = object as PFObject? {
                            svc!.chatRoom = testChatRoom
                            svc!.delegate = self
                            svc!.loadChatRoom()
                        } 
                    }
                })
                
            } else {
                GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internet, please check your connection and try again.", view: self)
            }
            
        }
        
    }
    
    private func getChatRooms() {
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            let query = PFQuery(className: "chatRoom").whereKey("user1", equalTo: PFUser.currentUser()!)
            let queryInverse = PFQuery(className: "chatRoom").whereKey("user2", equalTo: PFUser.currentUser()!)
            let queryCombined = PFQuery.orQueryWithSubqueries([query, queryInverse]).orderByDescending("updatedAt")
            queryCombined.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if error == nil {
                    self.chatRooms = objects as [PFObject]!
                    let length:Int = objects!.count as Int
                    for x in 0..<length {
                        let object = (objects as [PFObject]!)[x]
                        let user1 = object["user1"] as! PFUser
                        let user2 = object["user2"] as! PFUser
                        
                        if (PFUser.currentUser()!.isEqual(user1)) {
                            self.otherUsers.append(user2)
                            
                        }
                        else if (PFUser.currentUser()!.isEqual(user2)){
                            self.otherUsers.append(user1)
                            
                        }
                    }
                    print(self.chatRooms)
                    self.chatRoomsTableView.reloadData()
                }
                else {
                    print("\(error)")
                }
            }
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internet, please check your connection and try again.", view: self)
        }
    }
    
    private func handleColors() {
        self.view.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.chatRoomsTableView.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.chatRoomsTableView.separatorColor = GlobalConstants.Colors.tableViewSeparatorColor
    }

}
