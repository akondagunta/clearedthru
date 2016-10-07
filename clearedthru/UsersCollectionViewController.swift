//
//  UsersCollectionViewController.swift
//  clearedthru
//
//  Created by Avinash Kondagunta on 9/30/16.
//  Copyright © 2016 avinash kondagunta. All rights reserved.
//

import UIKit
import FirebaseDatabase


class UsersCollectionViewController: UICollectionViewController {
  
  private let reuseIdentifier = "CollectionViewCell"
  var databaseRef = FIRDatabase.database().reference()
  var usersDict = NSDictionary?()
  
  var userNamesArray = [String]()
  var userImagesArray = [String]()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      self.view.backgroundColor = UIColor.whiteColor()
      
      self.databaseRef.child("user_profile").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
        self.usersDict = snapshot.value as! [String : AnyObject] as NSDictionary
        // ...
        
        
        for(userId,details) in self.usersDict! {
          let img = details.objectForKey("profile_pic_small") as! String
          let name = details.objectForKey("name") as! String
          let firstname = name.componentsSeparatedByString(" ")[0]
          
          self.userNamesArray.append(firstname)
          self.userImagesArray.append(img)
          self.collectionView?.reloadData()
        }
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.userImagesArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
      let imageUrl = NSURL(string:userImagesArray[indexPath.row])
      
      let imageData = NSData(contentsOfURL: imageUrl!)
      
      cell.userImage.image = UIImage(data: imageData!)
      
      cell.userName.text = userNamesArray[indexPath.row]
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
