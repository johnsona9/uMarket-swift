//
//  EditPostViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/10/15.
//
//

import UIKit
import Parse

class EditPostViewController: UIViewController {

    var initialObject:PFObject!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editionTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.text = self.initialObject["postTitle"] as? String
        self.editionTextField.text = self.initialObject["postEdition"] as? String
        self.classTextField.text = self.initialObject["postClass"] as? String
        self.costTextField.text = self.initialObject["postCost"] as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveButtonTouch(sender: AnyObject) {
        
        PFQuery(className: "post").getObjectInBackgroundWithId(self.initialObject.objectId!, block: { (object, error) -> Void in
            if (error == nil) {
                object!["postTitle"] = self.titleTextField.text
                object!["postEdition"] = self.editionTextField.text
                object!["postClass"] = self.classTextField.text
                object!["postCost"] = self.costTextField.text
                object!.saveInBackgroundWithBlock { (success, error) -> Void in
                    if (success == true) {
                        if (error == nil) {
                            self.dismissViewControllerAnimated(true, completion: nilq)
                        }
                    }
                    else {
                        println("error updating object")
                    }
                    
                }
            }
        })
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
