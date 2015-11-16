//
//  SignUpViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 11/15/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import Parse
import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet var firstNameTextField:PaddedTextField!
    @IBOutlet var lastNameTextField:PaddedTextField!
    @IBOutlet var userNameTextField:PaddedTextField!
    @IBOutlet var passwordTextField:PaddedTextField!
    @IBOutlet var emailTextField:PaddedTextField!

    
    @IBAction func backArrowButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        var firstName = self.firstNameTextField.text
        var lastName = self.lastNameTextField.text
        var username = self.userNameTextField.text
        var password = self.passwordTextField.text
        var email = self.emailTextField.text
        // Validate the text fields
//        if username?.characters.count < 5 {
//            var alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
//            alert.show()
//            
//        } else 
//        if password?.characters.count < 8 {
//            var alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
//            alert.show()
        
//        } else 
        
        if email?.characters.count < 8 {
            var alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else {
            // Run a spinner to show a task in progress
            var spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            var newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.setValue(firstName, forKey: "firstName")
            newUser.setValue(lastName, forKey: "lastName")
            newUser.setValue(email, forKey: "email")
            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    //error case
                    let alertController = UIAlertController(title: "Please Try Again", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(ok)
                    alertController.view.tintColor = UIColor.In2DeepPurple()
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    //success case
                    let userName = PFUser.currentUser()!.username!
                    let alertController = UIAlertController(title: "Success", message: "\(userName)님, 가입/로그인에 성공하셨습니다", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(ok)
                    alertController.view.tintColor = UIColor.In2DeepPurple()
                    self.presentViewController(alertController, animated: true, completion: nil)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //do some success navigation
                        let revealVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.window!.rootViewController = revealVC
                        appDelegate.setUpNavBarAndStatusBarImages()
                    })
                }
            })
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
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
