//
//  postImageViewController.swift
//  Instagram
//
//  Created by Luke de Castro on 3/16/15.
//  Copyright (c) 2015 Luke de Castro. All rights reserved.
//

import UIKit

class postImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var photoSelected:Bool = false
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var caption: UITextField!
    @IBOutlet var imagePreview: UIImageView!
    @IBAction func selectImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        
        if sender.tag == 1 {
            image.sourceType = UIImagePickerControllerSourceType.Camera
        }
        else {
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imagePreview.image = image
        photoSelected = true
    }
    
    
    @IBAction func postButtonPressed(sender: AnyObject) {
        
        if photoSelected {
            
            var activityIndicator = UIActivityIndicatorView()
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var post = PFObject(className: "Post")
            post["title"] = caption.text
            post["username"] = PFUser.currentUser().username
            
            post.saveInBackgroundWithBlock({(success: Bool!, error: NSError! ) -> Void in
                
                if success == false {
                
                    var error = UIAlertView()
                    error.title = "Could Not Post Image"
                    error.message = "Please try again later"
                    error.addButtonWithTitle("Ok")
                    
                    activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    error.show()
                
                } else {
                    
                    let imageData = UIImagePNGRepresentation(self.imagePreview.image)
                    let imageFile = PFFile(name: "image.png", data: imageData)
                    
                    post["imageFile"] = imageFile
                    
                    post.saveInBackgroundWithBlock {(success: Bool!, error: NSError!) -> Void in
                    
                    if success == false {
                        
                        var error = UIAlertView()
                        error.title = "Could Not Post Image"
                        error.message = "Please try again later"
                        error.addButtonWithTitle("Ok")
                        
                        activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        error.show()
                    } else {
                        
                        println("success")
                        var error = UIAlertView()
                        error.title = "Yay!"
                        error.message = "Post Successful"
                        error.addButtonWithTitle("Ok")
                        
                        error.show()
                        
                        self.photoSelected = false
                        self.imagePreview.image = UIImage(named: "blankPerson.png")
                        self.caption.text = ""
                        activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()


                    }
                }

                }
            })
            
        }
        
    }
    override func viewDidLoad() {
        
        photoSelected = false
        imagePreview.image = UIImage(named: "blankPerson.png")
        caption.text = ""
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    @IBOutlet var signOutButtonPressed: [UIToolbar]!
    
    @IBAction func signOutButton(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("logOutSeg", sender: self)
    }
}
