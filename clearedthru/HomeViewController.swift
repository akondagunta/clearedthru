//
//  HomeViewController.swift
//  clearedthru
//
//  Created by Avinash Kondagunta on 9/27/16.
//  Copyright © 2016 avinash kondagunta. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class HomeViewController: UIViewController {

  
  
  @IBOutlet weak var userDisplayName: UILabel!
  
  @IBOutlet weak var userProfileImage: UIImageView!
  
  
  @IBAction func didTapLogout(sender: AnyObject) {
    // signs the user out of Firebase app
    try! FIRAuth.auth()!.signOut()
    
    //sign the user out of facebook app
    FBSDKAccessToken.setCurrentAccessToken(nil)
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let viewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginView")
    self.presentViewController(viewController, animated: true, completion: nil)

  }
  
  
  
  /*
  @IBAction func didTapLogout(sender: AnyObject) {
    
    // signs the user out of Firebase app
    try! FIRAuth.auth()!.signOut()
    
    //sign the user out of facebook app
    FBSDKAccessToken.setCurrentAccessToken(nil)
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let viewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginView")
    self.presentViewController(viewController, animated: true, completion: nil)

    
  }
  */
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.width/2
      self.userProfileImage.clipsToBounds = true
      
      if let user = FIRAuth.auth()?.currentUser {
        // User is signed in.
        let name = user.displayName
        let email = user.email
        let photoUrl = user.photoURL
        let uid = user.uid
        
        self.userDisplayName.text = name
        
        // reference to the Firebase storage service
        let storage = FIRStorage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.referenceForURL("gs://clearedthru.appspot.com")
        
        let profilePicRef = storageRef.child(user.uid + "/profile_pic.jpg")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        profilePicRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
          if (error != nil) {
            // Uh-oh, an error occurred!
            print("Unable to download image")
          } else {
            // Data for "images/island.jpg" is returned
            // ... let islandImage: UIImage! = UIImage(data: data!)
            if(data != nil) {
              print("User already has an image. No need to download from Facebook")
              self.userProfileImage.image = UIImage(data: data!)
            }
          }
        }
        
        if(self.userProfileImage.image == nil) {
        
        var profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300, "width":300, "redirect":false], HTTPMethod: "GET")
        profilePic.startWithCompletionHandler({(connection, result, error) -> Void in
          if(error == nil)
          {
            let dictonary = result as? NSDictionary
            let data = dictonary?.objectForKey("data")
            
            let urlPic = (data?.objectForKey("url"))! as! String
            
            if let imageData = NSData(contentsOfURL: NSURL(string:urlPic)!)
            {
              let uploadTask = profilePicRef.putData(imageData, metadata: nil) {
                metadata, error in
                if(error == nil)
                {
                  // size, contentType or downloadURL
                  let downloadUrl = metadata!.downloadURL
                  
                } else
                {
                  print("error downloading profile pic")
                }
              }
              self.userProfileImage.image = UIImage(data: imageData)
            }
          }
        })
        }
        
      } else {
        // No user is signed in.
      }
      
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
