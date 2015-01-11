//
//  SetTimeViewController.swift
//  BMWShareNow
//
//  Created by Jasper Sone on 1/11/15.
//  Copyright (c) 2015 Papafish. All rights reserved.
//

import UIKit

class SetTimeViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!

    var locationSelected: String!
    var queryName: String!
    var selectedMinute: [String:String]!
    var minutesArrayOfDict: [[String:String]] = [["minutes": "0", "description": "Now"], ["minutes": "15", "description": "In 15 Minutes"], ["minutes": "30", "description": "In 30 Minutes"], ["minutes": "L", "description": "Later"]]
    var numberSelected: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mainLabel.text = self.queryName
        self.subLabel.text = "at \(self.locationSelected)"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.view.animate(delayed: false, completionHandler: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        if segue.identifier == "Leave Now" {
            var destController: LeaveNowViewController = segue.destinationViewController as LeaveNowViewController
            destController.selectedMinute = self.selectedMinute
            destController.numberSelected = self.numberSelected
            destController.locationSelected = self.locationSelected
            destController.queryName = self.queryName
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        println("In function \(__FUNCTION__)")
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println("In function \(__FUNCTION__)")
        
        return self.minutesArrayOfDict.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        println("In function \(__FUNCTION__)")
        
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        println("In function \(__FUNCTION__)")
        
//        var headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("HEADER_VIEW_NAME") as HEADERVIEW
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        println("In function \(__FUNCTION__)")
        
        // includes 1px separator
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        println("In function \(__FUNCTION__)")
    
        var cell = tableView.dequeueReusableCellWithIdentifier("Minute", forIndexPath: indexPath) as TimeTableViewCell
        cell.minuteLabel.text = self.minutesArrayOfDict[indexPath.item]["minutes"]
        cell.mainTitle.text = self.minutesArrayOfDict[indexPath.item]["description"]
        cell.fromValue = 0.001
        cell.toValue = Float(indexPath.item) / 4
        cell.setUpBackground()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("In function \(__FUNCTION__)")
        
        self.selectedMinute = self.minutesArrayOfDict[indexPath.item]
        self.numberSelected = indexPath.item
        self.performSegueWithIdentifier("Leave Now", sender: self)
        
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
