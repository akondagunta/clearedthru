//
//  ViewController.swift
//  clearedthru
//
//  Created by avinash kondagunta on 9/26/16.
//  Copyright © 2016 avinash kondagunta. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
  
  @IBOutlet weak var aivLoadingSpinner: UIActivityIndicatorView!
  

    var loginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        // check if user is already signed in:
      FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
        if let user = user {
          // User is signed in.
          // Move user to the home screen
          let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
          let homeViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeView")
          self.presentViewController(homeViewController, animated: true, completion: nil)
          
        } else {
          // No user is signed in.
          // Show the user the login button
          // Optional: Place the button in the center of your view.
          self.loginButton.center = self.view.center
          
          // In your viewDidLoad method:
          self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
          self.loginButton.delegate = self;
          self.view!.addSubview(self.loginButton)
        }
      }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
      print("User Logged In!")
      
      self.loginButton.hidden = true
      
      aivLoadingSpinner.startAnimating()
      
      if(error != nil) {
        // handle errors here
        loginButton.hidden = false
        aivLoadingSpinner.stopAnimating()
        
      } else if(result.isCancelled) {
        //
        loginButton.hidden = false
        aivLoadingSpinner.stopAnimating()
      } else {
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
          // handle logged in user
        }
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
          print ("User logged in to firebase app: " + (user?.displayName)!)
        }
        
      }
      

    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out.")
    }


}

