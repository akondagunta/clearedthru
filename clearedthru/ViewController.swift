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

    var loginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Optional: Place the button in the center of your view.
        loginButton.center = self.view.center
        
        // In your viewDidLoad method:
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self;
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In!")
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            // handle logged in user
        }
        
        FIRAuth.auth()?.signInWithCredential(<#T##credential: FIRAuthCredential##FIRAuthCredential#>) { (user, error) in
            print ("User logged in to firebase app: " + (user?.displayName)!)
        }

    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out.")
    }


}

