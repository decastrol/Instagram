//
//  userTableViewController.swift
//  Instagram
//
//  Created by Luke de Castro on 3/9/15.
//  Copyright (c) 2015 Luke de Castro. All rights reserved.
//


import UIKit

class userTableViewController: UITableViewController {
    
    var userArray = [String]()
    var follow = [Bool]()
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        println(PFUser.currentUser())
        updateUsers()
                //create and add refresh function
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        if follow.count > indexPath.row {
        
        if follow[indexPath.row] {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        }
        cell.textLabel?.text = userArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            var query = PFQuery(className:"follow")
            query.whereKey("follower", equalTo: PFUser.currentUser().username)
            query.whereKey("following", equalTo: cell.textLabel?.text)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    println(objects)
                    //println("Successfully retrieved \(objects.count) users.")
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            object.delete()
                            
                        }
                    }
                } else {
                    // Log details of the failure
                    println("Error: \(error) \(error.userInfo!)")
                }
            }
        } else {
        
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            var query = PFQuery(className: "follow")
            var follows = PFObject(className: "follow")
            follows["following"] = cell.textLabel?.text
            follows["follower"] = PFUser.currentUser().username
            
            follows.saveInBackground()
        }
    }
    
    func updateUsers() {
        var query = PFUser.query()
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            
            self.userArray.removeAll(keepCapacity: true)
            
            var isFollowing:Bool
            for object in objects {
                var user: PFUser = object as PFUser
                
                if user.username != PFUser.currentUser().username {
                    
                    self.userArray.append(user.username)
                    
                    self.tableView.reloadData()
                }
                
                var isFollowing = false
                
                var query = PFQuery(className:"follow")
                query.whereKey("follower", equalTo: PFUser.currentUser().username)
                query.whereKey("following", equalTo: user.username)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        // The find succeeded.
                        println(objects)
                        //println("Successfully retrieved \(objects.count) users.")
                        // Do something with the found objects
                        if let objects = objects as? [PFObject] {
                            for object in objects {
                                
                                isFollowing = true
                            }
                            
                            self.follow.append(isFollowing)
                            self.tableView.reloadData()
                        }
                    } else {
                        // Log details of the failure
                        println("Error: \(error) \(error.userInfo!)")
                    }
                    self.refresher.endRefreshing()
                    
                }
            }
        })

    }
    
    func refresh() {
        println("refreshed")
        updateUsers()
    }
    
}
