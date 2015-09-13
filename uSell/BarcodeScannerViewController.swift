//
//  BarcodeScannerViewController.swift
//  uSell
//
//  Created by Adam Johnson on 8/19/15.
//
//

import UIKit
import AVFoundation
import SwiftyJSON

protocol BarcodeScannerViewControllerDelegate {
    func readInJSON(controller: UIViewController, title: String, author: String, imageLink: String)
}

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    var json : String = ""
    var delegate: BarcodeScannerViewControllerDelegate?
    var backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleColors()
        self.handleBackButton()
        // Allow the view to resize freely
        self.highlightView.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleRightMargin
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        
        // Add it to our controller's view as a subview.
        self.view.addSubview(self.highlightView)
        
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the "var" keyword and not "let"
        var error : NSError? = nil
        
        
        let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        
        // If our input is not nil then add it to the session, otherwise we're kind of done!
        if input != nil {
            session.addInput(input)
        }
        else {
            // This is fine for a demo, do something real with this in your app. :)
            println(error)
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
        previewLayer.frame = CGRectMake(0, self.view.frame.height * 3 / 25, self.view.frame.width, self.view.frame.height - self.view.frame.height * 3 / 25)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        // Start the scanner. You'll have to end it yourself later.
        session.startRunning()
        
    }
    
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var highlightViewRect = CGRectZero
        
        var barCodeObject : AVMetadataObject!
        
        var detectionString : String!
        
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                
                if metadata.type == barcodeType {
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                    
                    highlightViewRect = barCodeObject.bounds
                    
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    
                    self.session.stopRunning()
                    break
                }
                
            }
        }
        
        getBookInfo(detectionString)
        self.highlightView.frame = highlightViewRect
        self.view.bringSubviewToFront(self.highlightView)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func getBookInfo(isbn: String) {
        var url: String = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn;
        var request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        var authors = ""
        var titles = ""
        var imageLink = ""
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: error) as? NSDictionary {
                
                
                if let arrayOfTitles = jsonResult.valueForKeyPath("items.volumeInfo.title") as? [String] {
                    titles = ", ".join(arrayOfTitles)
                    println("titles: \(titles)")
                } else {
                    println("titles error")
                    println(jsonResult.valueForKeyPath("items.volumeInfo.title"))
                }
                if let arrayOfAuthors = jsonResult.valueForKeyPath("items.volumeInfo.authors") as? [[String]] {
                    authors = ", ".join(arrayOfAuthors[0])
                    println("authors: \(authors)")
                } else {
                    println("authors error")
                    println(jsonResult.valueForKeyPath("items.volumeInfo.authors")?[0])
                }
                if let imageLinks = jsonResult.valueForKeyPath("items.volumeInfo.imageLinks.smallThumbnail") as? [String] {
                    imageLink = ", ".join(imageLinks)
                    println("imageLink: \(imageLink)")
                } else {
                    println("images error")
                    println(jsonResult.valueForKeyPath("items.volumeInfo.imageLinks.smallThumbnail"))
                }
                
                self.delegate?.readInJSON(self, title: titles, author: authors, imageLink: imageLink)
                
            } else {
                GlobalConstants.AlertMessage.displayAlertMessage("Error fetching data from barcode, please try again.", view: self)
            }
            
            
        })
    }
    
    func backButtonTouch () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func handleColors() {
        self.backButton.setTitleColor(GlobalConstants.Colors.buttonTextColor, forState: UIControlState.Normal)
        self.backButton.backgroundColor = GlobalConstants.Colors.buttonBackgroundColor
//        self.backButton.layer.cornerRadius = 5
//        self.backButton.layer.borderWidth = 1
//        self.backButton.layer.borderColor = GlobalConstants.Colors.buttonBackgroundColor.CGColor
    }
    
    private func handleBackButton() {
        var frame = self.view.frame
        self.backButton.setTitle("Back", forState: .Normal)
        self.backButton.titleLabel?.font = self.backButton.titleLabel?.font.fontWithSize(24)
        self.backButton.frame = CGRectMake(0, 0, frame.width, frame.height * 3 / 25)
        self.backButton.addTarget(self, action: Selector("backButtonTouch"), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.backButton)
        
    }
    
}