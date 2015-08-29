//
//  MainViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/10/15.
//
//

import UIKit
import Parse

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var postsList = [PFObject]()
    var filteredPostsList = [PFObject]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.getPosts()
        self.handleColors()
        var rightItem:UIBarButtonItem = UIBarButtonItem(title: "post", style: .Plain, target: self, action: "postSegue")
        var chatsItem:UIBarButtonItem = UIBarButtonItem(title: "chats", style: .Plain, target: self, action: "chatsSegue")
        self.navigationItem.rightBarButtonItems = [rightItem, chatsItem]
        var leftItem:UIBarButtonItem = UIBarButtonItem(title: "logout", style: .Plain, target: self, action: "logoutUser")
        self.navigationItem.leftBarButtonItem = leftItem
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("mainToPostDetailsSegue", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        if tableView == self.searchDisplayController!.searchResultsTableView {
            cell.textLabel?.text = filteredPostsList[indexPath.row]["postTitle"] as? String
        } else {
            cell.textLabel?.text = postsList[indexPath.row]["postTitle"] as? String
        }
        cell.textLabel?.textColor = GlobalConstants.Colors.goldColor
        cell.backgroundColor = GlobalConstants.Colors.garnetColor
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredPostsList.count
        } else {
            return self.postsList.count
        }
    }
    
    func postSegue() {
        performSegueWithIdentifier("mainToMyPostsSegue", sender: self)
    }
    
    func chatsSegue() {
        performSegueWithIdentifier("mainToChatsSegue", sender: self)
    }
    
    func logoutUser() {
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            PFUser.logOutInBackgroundWithBlock { (error) -> Void in
                if error == nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internect, please check your connection and try again.", view: self)
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        
        self.filteredPostsList = self.postsList.filter {
            ($0.objectForKey("postTitle")! as! String).rangeOfString(searchText) != nil
        }
        
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    private func getPosts() {
        var postsQuery = PFQuery(className: "post").whereKey("poster", notEqualTo: PFUser.currentUser()!)
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            postsQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                if (error == nil) {
                    if let postObjects = objects as? [PFObject] {
                        for post in postObjects {
                            self.postsList.append(post)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internect, please check your connection and try again.", view: self)
        }
        
    }
    
    private func handleColors() {
        self.view.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.tableView.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.tableView.separatorColor = GlobalConstants.Colors.goldColor
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mainToPostDetailsSegue") {
            var svc = segue.destinationViewController as! PostDetailsViewController
            svc.post = self.postsList[(sender as! NSIndexPath).row]
        }
    
    }


}
