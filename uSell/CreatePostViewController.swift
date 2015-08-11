//
//  CreatePostViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/10/15.
//
//

import UIKit
import Parse

protocol CreatePostViewControllerDelegate {
    func updateTableView(controller: CreatePostViewController, object: PFObject)
}

class CreatePostViewController: UIViewController {

    var delegate: CreatePostViewControllerDelegate?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var editionTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonTouch(sender: AnyObject) {
        let postTitle = titleTextField.text
        let postClass = classTextField.text
        let postEdition = editionTextField.text
        let postCost = costTextField.text
        
        if (postClass != "" && postTitle != "" && postCost != "") {
            
            var newPost = PFObject(className: "post")
            newPost.setObject(postTitle, forKey: "postTitle")
            newPost.setObject(postClass, forKey: "postClass")
            newPost.setObject(postEdition, forKey: "postEdition")
            newPost.setObject(postCost, forKey: "postCost")
            newPost.setObject(PFUser.currentUser()!, forKey: "poster")
            newPost.saveInBackgroundWithBlock({ (success: Bool, error: NSError? ) -> Void in
                
                if (error == nil) {
                    self.delegate!.updateTableView(self, object: newPost)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    //put an alert in here
                }
                
            })
            
            
        }

    }

    @IBAction func cancelButtonTouch(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)

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
