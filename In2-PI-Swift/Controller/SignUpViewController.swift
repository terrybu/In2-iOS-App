//
//  SignUpViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 11/15/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var firstNameTextField:PaddedTextField!
    @IBOutlet var lastNameTextField:PaddedTextField!
    @IBOutlet var passwordTextField:PaddedTextField!
    @IBOutlet var confirmPasswordTextField:PaddedTextField!
    @IBOutlet var emailTextField:PaddedTextField!
    @IBOutlet var birthdayDatePicker: UIDatePicker!

    convenience init() {
        self.init(nibName: "SignUpViewController", bundle: nil)
        //initializing the view Controller form specified NIB file
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "회원가입"
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        emailTextField.delegate = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarSignUp"), forBarMetrics: UIBarMetrics.Default)
        //for the longest time, I was wondering why sometimes navigation bar background would look a little lighter than the statusbar backround that Jin made me ... it was because they make it damn translucent by default
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        let statusBarBackgroundView = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.size.width, height: 20))
        statusBarBackgroundView.backgroundColor = UIColor(patternImage: UIImage(named:"status_bar")!)
        self.navigationController?.navigationBar.addSubview(statusBarBackgroundView)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "btn_back"), style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonPressed")
        navigationItem.leftBarButtonItem = backButton
    }
    
    func backButtonPressed() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let firstName = self.firstNameTextField.text
        let lastName = self.lastNameTextField.text
        let password = self.passwordTextField.text
        let confirmationPassword = self.confirmPasswordTextField.text
        let email = self.emailTextField.text
        
        if validatedUserInputInTextFields(firstName, lastName: lastName, password: password, confirmationPassword: confirmationPassword, email: email, viewController: self) == false {
            return
            //stop any New User Creation because it didn't pass validation
        }
        
        createNewUserOnFirebaseAndDirectToHomeScreen(email!, password: password!, firstName: firstName!, lastName: lastName!, birthday: self.birthdayDatePicker.date)
    }

    private func createNewUserOnFirebaseAndDirectToHomeScreen(email: String, password: String, firstName: String, lastName: String, birthday: NSDate) {
        // Run a spinner to show a task in progress
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        spinner.startAnimating()
        
        FirebaseManager.sharedManager.createUser(email, password: password, firstName: firstName, lastName: lastName, birthdayString: CustomDateFormatter.sharedInstance.convertDateToFirebaseStringFormat(birthday), completion: {
            (success) -> Void in
            spinner.stopAnimating()
            if !success {
                let alertController = UIAlertController(title: "Please Try Again", message: "회원가입이 실패하였습니다. 다시 시도해주세요.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(ok)
                alertController.view.tintColor = UIColor.In2DeepPurple()
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                UIAlertController.presentAlert(self, alertTitle: "가입 성공", alertMessage: "앱 가입에 성공하셨습니다!", confirmTitle: "OK")
                //Upon success, check if it's first time run, if it is, show walkthrough. If not, show home screen.
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                WalkthroughManager.sharedInstance.showHomeScreen(self.view)
            }
        })
    }

    private func validatedUserInputInTextFields(firstName: String?, lastName: String?, password: String?, confirmationPassword: String?, email: String?, viewController: SignUpViewController) -> Bool {
        // Validate the text fields
        if let password = password, confirmPW = confirmationPassword, email = email {
            if password.characters.count <= 3 {
                var alert = UIAlertView(title: "Invalid Password Input", message: "Password must be greater than 3 characters", delegate: viewController, cancelButtonTitle: "OK")
                alert.show()
                return false
            }
            if !isValidEmail(email) {
                let alert = UIAlertView(title: "Invalid Email Input", message: "Please enter a valid email address", delegate: viewController, cancelButtonTitle: "OK")
                alert.show()
                return false
            }
            if confirmPW != password {
                let alert = UIAlertView(title: "Passwords Do Not Match", message: "Please make sure you've correctly entered your password in the confirmation field", delegate: viewController, cancelButtonTitle: "OK")
                alert.show()
                return false
            }
        }
        return true
    }

    
    
    
    //MARK: UITextFieldDelegate Methods
    
    /**
    * Called when 'return' key pressed. return NO to ignore.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
    * Called when the user click on the view (outside the UITextField).
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Email validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(testStr)
    }

}
