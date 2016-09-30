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
import Firebase
import FirebaseStorage

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
          let homeViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TabBarControllerView")
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
          // when the user logs in for the first time, we'll store the users name and the users email on their profile page.
          // also store the small version of the profile picture in the database and in the storage
          
          if(error == nil)
          {
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://clearedthru.appspot.com")
            let profilePicRef = storageRef.child(user!.uid + "/profile_pic_small.jpg")
            
            //store the userId
            let userId = user?.uid
            let databaseRef = FIRDatabase.database().reference()
            
            databaseRef.child("user_profile").child(userId!).child("profile_pic_small").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
              
              let profile_pic = snapshot.value as? String?
              
              if(profile_pic == nil)
              {
                if let imageData = NSData(contentsOfURL: user!.photoURL!)
                {
                  let uploadTask = profilePicRef.putData(imageData, metadata:nil){
                    metadata, error in
                      if(error == nil)
                      {
                        let downloadURL = metadata!.downloadURL
                        
                        databaseRef.child("user_profile").child("\(user!.uid)/profile_pic_small").setValue(downloadURL()!.absoluteString)
                        
                      }
                  }

                }
                
                //store data into the users profile page
                databaseRef.child("user_profile").child("\(user!.uid)/name").setValue(user?.displayName)
                databaseRef.child("user_profile").child("\(user!.uid)/gender").setValue("")
                databaseRef.child("user_profile").child("\(user!.uid)/age").setValue("")
                databaseRef.child("user_profile").child("\(user!.uid)/phone").setValue("")
                databaseRef.child("user_profile").child("\(user!.uid)/email").setValue("")
                databaseRef.child("user_profile").child("\(user!.uid)/website").setValue("")
                databaseRef.child("user_profile").child("\(user!.uid)/bio").setValue("")
                
              } else {
                print("User has logged in earlier!")
              }
              
              
            })
            
            
            
            
          }
          
          
          
        }
        
      }
      

    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out.")
    }


}

