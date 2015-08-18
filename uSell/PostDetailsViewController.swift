//
//  PostDetailsViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/10/15.
//
//

import UIKit
import Parse
import JSQMessagesViewController

class PostDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editionLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    var post:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.post["postTitle"] as? String
        self.editionLabel.text = self.post["postEdition"] as? String
        self.classLabel.text = self.post["postClass"] as? String
        self.costLabel.text = self.post["postCost"] as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chatButtonTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("postDetailsToChatSegue", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "postDetailsToChatSegue" {
            var svc = segue.destinationViewController as? ChatViewController
            var query = PFQuery(className: "chatRoom")
            query.whereKey("user1", equalTo: PFUser.currentUser()!)
            query.whereKey("user2", equalTo: self.post["poster"]!)
            var inverseQuery = PFQuery(className: "chatRoom")
            inverseQuery.whereKey("user2", equalTo: PFUser.currentUser()!)
            inverseQuery.whereKey("user1", equalTo: self.post["poster"]!)
            var queryCombined = PFQuery.orQueryWithSubqueries([query, inverseQuery])
            queryCombined.includeKey("user1")
            queryCombined.includeKey("user2")
            var testChatRoom = queryCombined.getFirstObject()
            
            if (testChatRoom != nil) {
                svc!.chatRoom = testChatRoom!
            }
            else {
                var newChatRoom = PFObject(className: "chatRoom")
                newChatRoom.setObject(PFUser.currentUser()!, forKey: "user1")
                newChatRoom.setObject(self.post["poster"]!, forKey: "user2")
                newChatRoom.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if error == nil {
                        svc!.chatRoom = newChatRoom
                        svc?.loadChatRoom()
                    }
                })
                
            }
            
        }
    }
    

}
