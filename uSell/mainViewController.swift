//
//  MainViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/10/15.
//
//

import UIKit
import Parse

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postsList = [PFObject]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.getPosts()
        var rightItem:UIBarButtonItem = UIBarButtonItem(title: "post", style: .Plain, target: self, action: "postSegue")
        self.navigationItem.rightBarButtonItem = rightItem
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
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = postsList[indexPath.row]["postTitle"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.postsList.count
    }
    
    func postSegue() {
        performSegueWithIdentifier("mainToMyPostsSegue", sender: self)
    }
    
    func logoutUser() {
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            if error == nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    private func getPosts() {
        var postsQuery = PFQuery(className: "post").whereKey("poster", notEqualTo: PFUser.currentUser()!)
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
        
    }
    
    
//     MARK: - Navigation
//
//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
        if (segue.identifier == "mainToPostDetailsSegue") {
            var svc = segue.destinationViewController as! PostDetailsViewController
            svc.post = self.postsList[(sender as! NSIndexPath).row]
        }
    
    }


}
