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

class CreatePostViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, BarcodeScannerViewControllerDelegate {

    var delegate: CreatePostViewControllerDelegate?
    var create = true
    var initialObject : PFObject!
    var image : PFFile?
    
    @IBOutlet weak var scanBarcodeButton: UIButton!
    
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
        let attString = NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName :GlobalConstants.Colors.pickerViewTextColor])
        return attString
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelection = pickerData[row]
    }
    
    @IBAction func scanBarcodeButtonTouch(sender: AnyObject) {
        
        self.performSegueWithIdentifier("createPostToBarcodeScannerSegue", sender: self)
    }
    
    func readInJSON(controller: UIViewController, title: String, author: String, imageLink: String) {
        if title == "" || author == "" || imageLink == "" {
            GlobalConstants.AlertMessage.displayAlertMessage("There was an issue finding some or all of this book's information", view: self)
            
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.titleTextField.text = title
            self.authorTextField.text = author
        }
        
        if let url = NSURL(string: imageLink) {
            if let data = NSData(contentsOfURL: url){
                self.image = PFFile(data: data)
            }
        }
    
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createPostToBarcodeScannerSegue" {
            var svc = segue.destinationViewController as! BarcodeScannerViewController
            svc.delegate = self
        }
    }
    
    private func handleColors() {
        self.view.backgroundColor = GlobalConstants.Colors.backgroundColor
        
        self.cancelButton.setTitleColor(GlobalConstants.Colors.buttonTextColor, forState: UIControlState.Normal)
        self.cancelButton.backgroundColor = GlobalConstants.Colors.buttonBackgroundColor
        self.cancelButton.layer.cornerRadius = 5
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.layer.borderColor = GlobalConstants.Colors.buttonBackgroundColor.CGColor
        
        self.postButton.setTitleColor(GlobalConstants.Colors.buttonTextColor, forState: UIControlState.Normal)
        self.postButton.backgroundColor = GlobalConstants.Colors.buttonBackgroundColor
        self.postButton.layer.cornerRadius = 5
        self.postButton.layer.borderWidth = 1
        self.postButton.layer.borderColor = GlobalConstants.Colors.buttonBackgroundColor.CGColor
        
        self.scanBarcodeButton.setTitleColor(GlobalConstants.Colors.buttonTextColor, forState: UIControlState.Normal)
        self.scanBarcodeButton.backgroundColor = GlobalConstants.Colors.buttonBackgroundColor
        self.scanBarcodeButton.layer.cornerRadius = 5
        self.scanBarcodeButton.layer.borderWidth = 1
        self.scanBarcodeButton.layer.borderColor = GlobalConstants.Colors.buttonBackgroundColor.CGColor
        
        self.titleTextField.backgroundColor = GlobalConstants.Colors.textFieldBackgroundColor
        self.titleTextField.textColor = GlobalConstants.Colors.textFieldTextColor
        
        self.editionTextField.backgroundColor = GlobalConstants.Colors.textFieldBackgroundColor
        self.editionTextField.textColor = GlobalConstants.Colors.textFieldTextColor
        
        self.costTextField.backgroundColor = GlobalConstants.Colors.textFieldBackgroundColor
        self.costTextField.textColor = GlobalConstants.Colors.textFieldTextColor
        
        self.authorTextField.backgroundColor = GlobalConstants.Colors.textFieldBackgroundColor
        self.authorTextField.textColor = GlobalConstants.Colors.textFieldTextColor
        
        
        
    }
    
    private func handleEditing() {
        if !self.create {
            self.postButton.setTitle("Save", forState: .Normal)
            
            self.titleTextField.text = self.initialObject["postTitle"] as? String
            self.editionTextField.text = self.initialObject["postEdition"] as? String
            self.costTextField.text = self.initialObject["postCost"] as? String
            self.authorTextField.text = self.initialObject["postAuthor"] as? String
            self.departmentPickerView.selectRow(find(pickerData, (self.initialObject["postDepartment"] as? String)!)!, inComponent: 0, animated: false)
            self.image = self.initialObject["image"] as? PFFile
            
            
        }
    }
    
    private func doEdit() {
        let title = self.titleTextField.text
        let author = self.authorTextField.text
        let cost = self.costTextField.text
        let edition = self.editionTextField.text
        
        if (cost.toInt() as Int!) == nil || (edition.toInt() as Int!) == nil {
            GlobalConstants.AlertMessage.displayAlertMessage("Your cost and or edition input is not in the correct form. Make sure they're whole numbers and submit again.", view: self)
        } else {
        
            if (cost != "" && title != "" && author != "") {
                
                let reachability = Reachability.reachabilityForInternetConnection()
                if (reachability.isReachable()) {
                    PFQuery(className: "post").getObjectInBackgroundWithId(self.initialObject.objectId!, block: { (object, error) -> Void in
                        if (error == nil) {
                            object!["postTitle"] = title
                            object!["postEdition"] = edition
                            object!["postDepartment"] = self.pickerSelection
                            object!["postCost"] = cost
                            object!["postAuthor"] = author
                            object!["image"] = self.image
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
                    GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internet, please check your connection and try again.", view: self)
                }
            }
        }
    }
    
    private func doCreate() {
        let postTitle = titleTextField.text
        let postEdition = editionTextField.text
        let postCost = costTextField.text
        let postAuthor = authorTextField.text
        if (postCost.toInt() as Int!) == nil || (postEdition.toInt() as Int!) == nil {
            GlobalConstants.AlertMessage.displayAlertMessage("Your cost and or edition input is not in the correct form. Make sure they're whole numbers and submit again.", view: self)
        } else {
        
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
                    newPost.setObject(self.image!, forKey: "image")
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
                    GlobalConstants.AlertMessage.displayAlertMessage("You aren't connected to the internet, please check your connection and try again.", view: self)
                }
                
                
            } else {
                GlobalConstants.AlertMessage.displayAlertMessage("You are missing some necessary fields", view: self)
            }
        }
    }

}
