//
//  MyPostsViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/10/15.
//
//

import UIKit
import Parse

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreatePostViewControllerDelegate {
    var postsList = [PFObject]()

    @IBOutlet weak var myPostsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPosts()
        self.handleColors()
        self.myPostsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        var rightItem:UIBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "newPostSegue")
        self.navigationItem.rightBarButtonItem = rightItem
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        myPostsTableView.reloadData() 
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("myPostsToEditPostSegue", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.myPostsTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = postsList[indexPath.row]["postTitle"] as? String
        cell.textLabel?.textColor = GlobalConstants.Colors.goldColor
        cell.backgroundColor = GlobalConstants.Colors.garnetColor
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            return true
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
        
            postsList[indexPath.row].deleteInBackground()
            postsList.removeAtIndex(indexPath.row)
            self.myPostsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)



        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.postsList.count
    }

    
    func newPostSegue() {
        var userQuery = PFUser.query()?.whereKey("objectId", equalTo: PFUser.currentUser()!.objectId!)
        userQuery?.getFirstObjectInBackgroundWithBlock({ (user, error) -> Void in
            if error == nil {
                if let currentUser : PFUser = user as? PFUser {
                    println(currentUser)
                    if currentUser.objectForKey("emailVerified") as! Bool {
                        self.performSegueWithIdentifier("myPostsToCreatePostSegue", sender: self)
                    } else {
                        GlobalConstants.AlertMessage.displayAlertMessage("You can't create posts until you've verified your email!", view: self)
                    }
                }
            }
            else {
                GlobalConstants.AlertMessage.displayAlertMessage("There was an error finding you in our database, please try again", view: self)
            }
        })
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "myPostsToCreatePostSegue") {
            var svc = segue.destinationViewController as! CreatePostViewController
            svc.delegate = self
        }
        else if (segue.identifier == "myPostsToEditPostSegue") {
            var svc = segue.destinationViewController as! EditPostViewController
            svc.initialObject = self.postsList[(sender as! NSIndexPath).row]
        }
        
    }
    
    // MARK - CreatePostViewControllerDelegate
    
    func updateTableView(controller: CreatePostViewController, object: PFObject) {
        self.postsList.append(object)
        self.myPostsTableView.reloadData()
    }

    private func getPosts() {
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            var postsQuery = PFQuery(className: "post").whereKey("poster", equalTo: PFUser.currentUser()!)
            postsQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                if (error == nil) {
                    if let postObjects = objects as? [PFObject] {
                        for post in postObjects {
                            self.postsList.append(post)
                        }
                        self.myPostsTableView.reloadData()
                    }
                }
            }
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internect, please check your connection and try again.", view: self)
        }
        
    }
    
    private func handleColors() {
        self.view.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.myPostsTableView.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.myPostsTableView.separatorColor = GlobalConstants.Colors.goldColor
    }

}
