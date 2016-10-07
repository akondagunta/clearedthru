//
//  ProfileTableViewController.swift
//  Pods
//
//  Created by Avinash Kondagunta on 9/28/16.
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileTableViewController: UITableViewController {
  
  var about = ["Name", "Gender", "Age", "Phone", "Email", "Website", "Bio"]
  var ref = FIRDatabase.database().reference()
  
  var user = FIRAuth.auth()?.currentUser
  
  
  @IBAction func tapUpdate(sender: AnyObject) {
    var index = 0
    while index < about.count {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      let cell: TextInputTableView? = self.tableView.cellForRowAtIndexPath(indexPath) as! TextInputTableView
      
      if cell?.myTextField.text != ""
      {
        let item: String = (cell?.myTextField.text!)!
        switch about[index]
        {
        case "Name":
          self.ref.child("user_profile").child("\(user!.uid)/Name").setValue(item)
        case "Gender":
          self.ref.child("user_profile").child("\(user!.uid)/Gender").setValue(item)
        case "Age":
          self.ref.child("user_profile").child("\(user!.uid)/Age").setValue(item)
        case "Phone":
          self.ref.child("user_profile").child("\(user!.uid)/Phone").setValue(item)
        case "Email":
          self.ref.child("user_profile").child("\(user!.uid)/Email").setValue(item)
        case "Website":
          self.ref.child("user_profile").child("\(user!.uid)/Website").setValue(item)
        case "Bio":
          self.ref.child("user_profile").child("\(user!.uid)/Bio").setValue(item)
        default:
          print("don't update")
          
        }
      }
      index+=1
    }
  }
  
  
    override func viewDidLoad() {
      super.viewDidLoad()

      self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
      
      var refHandle = self.ref.child("user_profile").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
        let usersDict = snapshot.value as! [String : AnyObject] as! NSDictionary
        // ...
        
        print(usersDict)
        let userDetails = usersDict.objectForKey(self.user!.uid)
        
        
        var index = 0
        while index < self.about.count {
          let indexPath = NSIndexPath(forRow: index, inSection: 0)
          let cell: TextInputTableView? = self.tableView.cellForRowAtIndexPath(indexPath) as! TextInputTableView
          
          let field:String = (cell?.myTextField.placeholder?.lowercaseString)!
          
          switch field
          {
            case "name":
            cell?.configure(userDetails?.objectForKey("Name") as? String, placeholder: "Name")
            case "gender":
              cell?.configure(userDetails?.objectForKey("Gender") as? String, placeholder: "Gender")
            case "age":
              cell?.configure(userDetails?.objectForKey("Age") as? String, placeholder: "Age")
            case "phone":
              cell?.configure(userDetails?.objectForKey("Phone") as? String, placeholder: "Phone")
            case "email":
              cell?.configure(userDetails?.objectForKey("Email") as? String, placeholder: "Email")
            case "website":
              cell?.configure(userDetails?.objectForKey("Website") as? String, placeholder: "Website")
            case "bio":
              cell?.configure(userDetails?.objectForKey("Bio") as? String, placeholder: "Bio")
            default:
              print("couldnt set field values")
              
          }
          index+=1
        }

        
      })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return about.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell:TextInputTableView = tableView.dequeueReusableCellWithIdentifier("TextInput", forIndexPath: indexPath) as! TextInputTableView

        // Configure the cell...
      cell.configure("",placeholder: "\(about[indexPath.row])")

        return cell
    }  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
