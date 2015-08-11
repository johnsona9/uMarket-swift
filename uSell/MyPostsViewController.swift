//
//  MyPostsViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/10/15.
//
//

import UIKit

class MyPostsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var rightItem:UIBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "newPostSegue")
        self.navigationItem.rightBarButtonItem = rightItem
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newPostSegue() {
        self.performSegueWithIdentifier("myPostsToCreatePostSegue", sender: self)
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
