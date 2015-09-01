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

class CreatePostViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var delegate: CreatePostViewControllerDelegate?
    var create = true
    var initialObject : PFObject!
    @IBOutlet weak var departmentPickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editionTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    let pickerData = GlobalConstants.Departments.departments
    var pickerSelection: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleColors()
        self.titleTextField.delegate = self
        self.editionTextField.delegate = self
        self.costTextField.delegate = self
        self.authorTextField.delegate = self
        self.pickerSelection = pickerData[0]
        handleEditing()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonTouch(sender: AnyObject) {
        if self.create {
            self.doCreate()
        } else {
            self.doEdit()
        }

    }

    @IBAction func cancelButtonTouch(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attString = NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName :GlobalConstants.Colors.goldColor])
        return attString
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelection = pickerData[row]
    }
    
    private func handleColors() {
        self.view.backgroundColor = GlobalConstants.Colors.backgroundColor
        self.cancelButton.setTitleColor(GlobalConstants.Colors.goldColor, forState: UIControlState.Normal)
        self.postButton.setTitleColor(GlobalConstants.Colors.goldColor, forState: UIControlState.Normal)
        self.titleTextField.backgroundColor = GlobalConstants.Colors.garnetColor
        self.titleTextField.textColor = GlobalConstants.Colors.goldColor
        self.editionTextField.backgroundColor = GlobalConstants.Colors.garnetColor
        self.editionTextField.textColor = GlobalConstants.Colors.goldColor
        self.costTextField.backgroundColor = GlobalConstants.Colors.garnetColor
        self.costTextField.textColor = GlobalConstants.Colors.goldColor
        self.authorTextField.backgroundColor = GlobalConstants.Colors.garnetColor
        self.authorTextField.textColor = GlobalConstants.Colors.goldColor
        
        
        
    }
    
    private func handleEditing() {
        if !self.create {
            self.postButton.setTitle("Save", forState: .Normal)
            
            self.titleTextField.text = self.initialObject["postTitle"] as? String
            self.editionTextField.text = self.initialObject["postEdition"] as? String
            self.costTextField.text = self.initialObject["postCost"] as? String
            self.authorTextField.text = self.initialObject["postAuthor"] as? String
            self.departmentPickerView.selectRow(find(pickerData, (self.initialObject["postDepartment"] as? String)!)!, inComponent: 0, animated: false)
            
            
        }
    }
    
    private func doEdit() {
        let title = self.titleTextField.text
        let author = self.authorTextField.text
        let cost = self.costTextField.text
        
        if (cost != "" && title != "" && author != "") {
            
            let reachability = Reachability.reachabilityForInternetConnection()
            if (reachability.isReachable()) {
                PFQuery(className: "post").getObjectInBackgroundWithId(self.initialObject.objectId!, block: { (object, error) -> Void in
                    if (error == nil) {
                        object!["postTitle"] = title
                        object!["postEdition"] = self.editionTextField.text
                        object!["postDepartment"] = self.pickerSelection
                        object!["postCost"] = cost
                        object!["postAuthor"] = author
                        object!.saveInBackgroundWithBlock { (success, error) -> Void in
                            if (success == true) {
                                if (error == nil) {
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                            }
                            else {
                                GlobalConstants.AlertMessage.displayAlertMessage("error updating object", view: self)
                            }
                            
                        }
                    }
                })
            } else {
                GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internect, please check your connection and try again.", view: self)
            }
        }
    }
    
    private func doCreate() {
        let postTitle = titleTextField.text
        let postEdition = editionTextField.text
        let postCost = costTextField.text
        let postAuthor = authorTextField.text
        
        if (postTitle != "" && postCost != "" && postAuthor != "") {
            let reachability = Reachability.reachabilityForInternetConnection()
            if (reachability.isReachable()) {
                var newPost = PFObject(className: "post")
                newPost.setObject(postTitle, forKey: "postTitle")
                newPost.setObject(self.pickerSelection, forKey: "postDepartment")
                newPost.setObject(postEdition, forKey: "postEdition")
                newPost.setObject(postCost, forKey: "postCost")
                newPost.setObject(postAuthor, forKey: "postAuthor")
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
            } else {
                GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internect, please check your connection and try again.", view: self)
            }
            
            
        } else {
            GlobalConstants.AlertMessage.displayAlertMessage("You are missing some necessary fields", view: self)
        }
    }

}
