//
//  HomeViewController.swift
//  clearedthru
//
//  Created by Avinash Kondagunta on 9/27/16.
//  Copyright © 2016 avinash kondagunta. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FirebaseAuth


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
        
        let data = NSData(contentsOfURL: photoUrl!)
        self.userProfileImage.image = UIImage(data: data!)
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
