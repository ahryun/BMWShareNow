//
//  ShareNowViewController.swift
//  BMWShareNow
//
//  Created by Jasper Sone on 1/10/15.
//  Copyright (c) 2015 Papafish. All rights reserved.
//

import UIKit

class ShareNowViewController: UIViewController {
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    var categories = [PFObject]()
    var queryName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        self.queryCategories()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.view.animate(delayed: false, completionHandler: nil)
    }
    
    func queryCategories() {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        var query = PFQuery(className: "Category")
        query.cachePolicy = kPFCachePolicyCacheThenNetwork
        query.findObjectsInBackgroundWithBlock() {
            (categories, err) in
            if err == nil {
                self.categories = categories as [PFObject]
                self.categoryTableView.reloadData()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        if segue.identifier == "Pick Location" {
            var destController: LocationsTableViewController = segue.destinationViewController as LocationsTableViewController
            destController.queryName = self.queryName
        }
    }
    
    @IBAction func navigateBack(sender: AnyObject) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /************************/
    // MARK: Table View
    /************************/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        println("In function \(__FUNCTION__)")
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println("In function \(__FUNCTION__)")
        
        return self.categories.count > 0 ? self.categories.count + 1 : 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        println("In function \(__FUNCTION__)")
        
        // includes 1px separator
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        println("In function \(__FUNCTION__)")
    
        var cell = tableView.dequeueReusableCellWithIdentifier("Category", forIndexPath: indexPath) as CategoryTableViewCell
        if indexPath.item < self.categories.count {
            var category = self.categories[indexPath.item]
            cell.categoryImageView.file = category["photo"] as PFFile
            cell.categoryImageView.loadInBackground(nil)
            cell.mainTitle.text = category["name"] as? String
            cell.subtitle.text = category["description"] as? String
            cell.setUpBackground()
        } else {
            cell.categoryImageView.image = UIImage(named: "search_circle")
            cell.mainTitle.text = "Other"
            cell.subtitle.text = "Search for more places"
            cell.setUpBackground(addCircle: false)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("In function \(__FUNCTION__)")
        
        if indexPath.item < self.categories.count {
            self.queryName = self.categories[indexPath.item]["name"] as String
        }
        self.performSegueWithIdentifier("Pick Location", sender: self)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("In function \(__FUNCTION__)")
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        println("In function \(__FUNCTION__)")
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        println("In function \(__FUNCTION__)")
        
        return 0
    }

}
