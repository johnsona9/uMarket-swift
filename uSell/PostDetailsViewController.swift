//
//  PostDetailsViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/10/15.
//
//

import UIKit
import Parse

class PostDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editionLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    var post:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.post["postTitle"] as? String
        self.editionLabel.text = self.post["postEdition"] as? String
        self.classLabel.text = self.post["postClass"] as? String
        self.costLabel.text = self.post["postCost"] as? String
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
