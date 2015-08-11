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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
