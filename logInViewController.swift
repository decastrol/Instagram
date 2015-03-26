//
//  logInViewController.swift
//  Instagram
//
//  Created by Luke de Castro on 3/2/15.
//  Copyright (c) 2015 Luke de Castro. All rights reserved.
//

import UIKit

class logInViewController: UIViewController {
    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
    @IBAction func login(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userName.text, password:password.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                // Do stuff after successful login.
                println("It worked")
                println(PFUser.currentUser())
                //PFUser.currentUser().username = user.username
                
                self.performSegueWithIdentifier("successLogIn", sender: self)
            } else {
                // The login failed. Check error to see why.
                var err = error
                //let errorString: NSString = error.userInfo["error"] as NSString
                // Show the errorString somewhere and let the user try again.
                var signUpErrorAlert = UIAlertView()
                signUpErrorAlert.title = "Error"
                signUpErrorAlert.message = "There has been an error"
                signUpErrorAlert.addButtonWithTitle("Ok")
                signUpErrorAlert.show()
            }
        }
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
}
