//
//  MainViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/10/15.
//
//

import UIKit
import Parse

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var postsList = [PFObject]()
    var filteredPostsList = [PFObject]()
    var searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setUpSearchController()
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search by title"
        
        searchController.searchBar.sizeToFit()

        tableView.tableHeaderView = searchController.searchBar
        
        
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
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        }
        if searchController.searchBar.text == "" {
            cell!.textLabel?.text = postsList[indexPath.row]["postTitle"] as? String
            cell!.detailTextLabel?.text = postsList[indexPath.row]["postAuthor"] as? String
        } else {
            cell!.textLabel?.text = filteredPostsList[indexPath.row]["postTitle"] as? String
            cell!.detailTextLabel?.text = filteredPostsList[indexPath.row]["postAuthor"] as? String
        }
        cell!.textLabel?.textColor = GlobalConstants.Colors.cellTextColor
        cell!.detailTextLabel?.textColor = GlobalConstants.Colors.cellDetailTextColor
        cell!.backgroundColor = GlobalConstants.Colors.cellBackgroundColor
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text == "" {
            return self.postsList.count
        } else {
            return self.filteredPostsList.count
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
                    var installation : PFInstallation = PFInstallation.currentInstallation()
                    installation["user"] = NSNull()
                    installation.saveInBackground()
                }
            }
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internet, please check your connection and try again.", view: self)
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        
        self.filteredPostsList = self.postsList.filter {
            ($0.objectForKey("postTitle")! as! String).lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        }
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text)
        tableView.reloadData()
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
        self.tableView.separatorColor = GlobalConstants.Colors.tableViewSeparatorColor
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mainToPostDetailsSegue") {
            var svc = segue.destinationViewController as! PostDetailsViewController
            svc.post = self.postsList[(sender as! NSIndexPath).row]
        }
    
    }


}
