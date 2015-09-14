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
    
    var titleLabel :UILabel!
    var authorLabel : UILabel!
    var editionLabel: UILabel!
    var departmentLabel: UILabel!
    var costLabel: UILabel!
    var chatButton: UIButton!
    
    var post:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createFrames()
        self.handleColors()
        let title = self.post["postTitle"] as? String
        let edition = self.post["postEdition"] as? String
        let department = self.post["postDepartment"] as? String
        let cost = self.post["postCost"] as? String
        let author = self.post["postAuthor"] as? String
        self.titleLabel.text = "Title: \(title!)"
        self.editionLabel.text = "Edition: \(edition!)"
        self.departmentLabel.text = "Dept: \(department!)"
        self.costLabel.text = "Cost: \(cost!)"
        self.authorLabel.text = "By: \(author!)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "postDetailsToChatSegue" {
            let reachability = Reachability.reachabilityForInternetConnection()
            if (reachability.isReachable()) {
                
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
                
                queryCombined.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                    if object == nil && error != nil {
                        var newChatRoom = PFObject(className: "chatRoom")
                        newChatRoom.setObject(PFUser.currentUser()!, forKey: "user1")
                        newChatRoom.setObject(self.post["poster"]!, forKey: "user2")
                        
                        svc!.chatRoom = newChatRoom
                        newChatRoom.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if error == nil {
                                //svc!.chatRoom = newChatRoom
                                svc!.loadChatRoom()
                            }
                        })
                        
                    } else if error == nil {
                        if object != nil {
                            svc!.chatRoom = object!
                            svc!.loadChatRoom()
                        }
                    }
                })
                
            } else {
                GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internet, please check your connection and try again.", view: self)
            }
            
        }
    }
    
    func chatButtonTouch() {
        var verified: AnyObject? = PFUser.currentUser()?.objectForKey("emailVerified")
        if (verified == nil || verified as! Bool == false) {
            var userQuery = PFUser.query()?.whereKey("objectId", equalTo: PFUser.currentUser()!.objectId!)
            userQuery?.getFirstObjectInBackgroundWithBlock({ (user, error) -> Void in
                if error == nil {
                    if let currentUser : PFUser = user as? PFUser {
                        println(currentUser)
                        if currentUser.objectForKey("emailVerified") as! Bool {
                            self.performSegueWithIdentifier("postDetailsToChatSegue", sender: self)
                        } else {
                            GlobalConstants.AlertMessage.displayAlertMessage("You can't chat until you've verified your email!", view: self)
                        }
                    }
                }
                else {
                    GlobalConstants.AlertMessage.displayAlertMessage("There was an error finding you in our database, please try again", view: self)
                }
            })
        } else {
            self.performSegueWithIdentifier("postDetailsToChatSegue", sender: self)
        }
        
        
    }
    
    private func handleColors() {
        
        self.view.backgroundColor = GlobalConstants.Colors.backgroundColor
        
        self.titleLabel.textColor = GlobalConstants.Colors.pickerViewTextColor
        self.editionLabel.textColor = GlobalConstants.Colors.pickerViewTextColor
        self.departmentLabel.textColor = GlobalConstants.Colors.pickerViewTextColor
        self.costLabel.textColor = GlobalConstants.Colors.pickerViewTextColor
        self.authorLabel.textColor = GlobalConstants.Colors.pickerViewTextColor
        
        self.chatButton.setTitleColor(GlobalConstants.Colors.buttonTextColor, forState: UIControlState.Normal)
        self.chatButton.backgroundColor = GlobalConstants.Colors.buttonBackgroundColor
        self.chatButton.layer.cornerRadius = 5
        self.chatButton.layer.borderWidth = 1
        self.chatButton.layer.borderColor = GlobalConstants.Colors.buttonBackgroundColor.CGColor
        
        
    }
    
    private func createFrames() {
        var frame = self.view.frame
        self.titleLabel = UILabel(frame: CGRectMake(frame.width / 16, frame.height * 1.2 / 8, frame.width * 14 / 16, frame.height * 1 / 8))
        self.titleLabel.text = "Title"
        self.view.addSubview(self.titleLabel)
        
        self.authorLabel = UILabel(frame: CGRectMake(frame.width / 16, frame.height * 1.2 / 4, frame.width * 14 / 16, frame.height / 8))
        self.authorLabel.text = "Author"
        self.view.addSubview(self.authorLabel)
        
        self.editionLabel = UILabel(frame: CGRectMake(frame.width / 15, frame.height * 1.8 / 4, frame.width * 6 / 15, frame.height / 16))
        self.editionLabel.text = "Edition"
        self.view.addSubview(self.editionLabel)
        
        self.departmentLabel = UILabel(frame: CGRectMake(frame.width * 8 / 15, frame.height * 1.8 / 4, frame.width * 6 / 15, frame.height / 16))
        self.departmentLabel.text = "Dept"
        self.view.addSubview(self.departmentLabel)
        
        self.costLabel = UILabel(frame: CGRectMake(frame.width / 15, frame.height * 2.2 / 4, frame.width * 6 / 15, frame.height / 16))
        self.costLabel.text = "Cost"
        self.view.addSubview(self.costLabel)
        
        
        self.chatButton = UIButton(frame: CGRectMake(frame.width * 8 / 15, frame.height * 2.2 / 4, frame.width * 6 / 15, frame.height / 16))
        self.chatButton.setTitle("Chat", forState: .Normal)
        self.chatButton.addTarget(self, action: Selector("chatButtonTouch"), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.chatButton)
    }
    

}
