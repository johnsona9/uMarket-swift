//
//  ChatRoomsViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/12/15.
//
//

import UIKit
import Parse

class ChatRoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var chatRooms = [PFObject]()
    var otherUsers = [PFUser]()
    
    @IBOutlet weak var chatRoomsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatRoomsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.getChatRooms()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("chatRoomsToChatSegue", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.chatRoomsTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        var username = self.otherUsers[indexPath.row].fetchIfNeeded()
        cell.textLabel?.text = username!["username"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.otherUsers.count
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "chatRoomsToChatSegue" {
            
            var svc = segue.destinationViewController as? ChatViewController
            var query = PFQuery(className: "chatRoom")
            query.whereKey("user1", equalTo: PFUser.currentUser()!)
            query.whereKey("user2", equalTo: otherUsers[(sender as! NSIndexPath).row])
            var inverseQuery = PFQuery(className: "chatRoom")
            inverseQuery.whereKey("user2", equalTo: PFUser.currentUser()!)
            inverseQuery.whereKey("user1", equalTo: otherUsers[(sender as! NSIndexPath).row])
            var queryCombined = PFQuery.orQueryWithSubqueries([query, inverseQuery])
            queryCombined.includeKey("user1")
            queryCombined.includeKey("user2")
            var testChatRoom = queryCombined.getFirstObject()
            println(testChatRoom)
            if (testChatRoom != nil) {
                svc!.chatRoom = testChatRoom!
            }
            else {
                var newChatRoom = PFObject(className: "chatRoom")
                newChatRoom.setObject(PFUser.currentUser()!, forKey: "user1")
                newChatRoom.setObject(otherUsers[(sender as! NSIndexPath).row], forKey: "user2")
                println(newChatRoom)
                newChatRoom.saveInBackground()
                svc!.chatRoom = newChatRoom
            }
            
        }
        
    }
    
    
    private func getChatRooms() {
        var query = PFQuery(className: "chatRoom").whereKey("user1", equalTo: PFUser.currentUser()!)
        var queryInverse = PFQuery(className: "chatRoom").whereKey("user2", equalTo: PFUser.currentUser()!)
        var queryCombined = PFQuery.orQueryWithSubqueries([query, queryInverse])
        queryCombined.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.chatRooms = objects as! [PFObject]
                var length:Int = objects!.count as Int
                println(length)
                for x in 0..<length {
                    var object = (objects as! [PFObject])[x]
                    println(object)
                    var user1 = object["user1"] as! PFUser
                    var user2 = object["user2"] as! PFUser
                    println(user1)
                    println(PFUser.currentUser()!.isEqual(user1))
                    println(PFUser.currentUser()!.isEqual(user2))
                    
                    if (PFUser.currentUser()!.isEqual(user1)) {
                        self.otherUsers.append(user2)
                        println(self.otherUsers)
                        
                    }
                    else if (PFUser.currentUser()!.isEqual(user2)){
                        println("user1")
                        self.otherUsers.append(user1)
                        println(self.otherUsers)
                        
                    }
                }
                println("reload")
                println(self.otherUsers)
                println(self.chatRooms)
                self.chatRoomsTableView.reloadData()
            }
            else {
                println("\(error)")
            }
        }
    }

}
