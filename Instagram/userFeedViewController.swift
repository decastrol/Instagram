//
//  userFeedViewController.swift
//  Instagram
//
//  Created by Luke de Castro on 3/23/15.
//  Copyright (c) 2015 Luke de Castro. All rights reserved.
//

import UIKit

class userFeedViewController: UITableViewController {

    var titles = [""]
    var usernames = [""]
    var images = [UIImageView]()
    var imageFiles = [PFFile]()
    override func viewDidLoad() {
        
        var getFollowUsersQuery = PFQuery(className: "follow")
        getFollowUsersQuery.whereKey("follower", equalTo: PFUser.currentUser().username)
            getFollowUsersQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
                
                var followedUser = String()
                for object in objects {
                    followedUser = object["following"] as String
                    
                    var query = PFQuery(className: "Post")
                    query.whereKey("username", equalTo: followedUser)
                    query.findObjectsInBackgroundWithBlock({
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        
                        if error == nil {
                        for object in objects {
                        
                        self.titles.append(object["title"] as String)
                        self.usernames.append(object["username"] as String)
                        self.imageFiles.append(object["imageFile"] as PFFile)
                        
                        self.tableView.reloadData()
                        }
                        }
                    })
                    
                }
            }
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageFiles.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 227
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var myCell: cell = self.tableView.dequeueReusableCellWithIdentifier("myCell") as cell
        
        myCell.title.text = titles[indexPath.row]
        myCell.userName.text = usernames[indexPath.row]
        
        if imageFiles.count > 0 {
        imageFiles[indexPath.row].getDataInBackgroundWithBlock ({
            (imageData: NSData!, error: NSError!) -> Void in
            
            if error == nil {
            let image = UIImage(data: imageData)
            myCell.postedImage.image = image
            }
            
            })
        }
        return myCell
    }
}
