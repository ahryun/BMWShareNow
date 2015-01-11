//
//  LocationsTableViewController.swift
//  BMWShareNow
//
//  Created by Jasper Sone on 1/10/15.
//  Copyright (c) 2015 Papafish. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController {

    var locationsArray = [NSMutableDictionary]()
    var queryName: String!
    var searchController: UISearchController!
    var resultsTableController: SearchTableViewController!
    var restoredState = SearchControllerRestorableState()
    var indexSelected: Int!
    
    struct RestorationKeys {
        static let viewControllerTitle = "ViewControllerTitleKey"
        static let searchControllerIsActive = "SearchControllerIsActiveKey"
        static let searchBarText = "SearchBarTextKey"
        static let searchBarIsFirstResponder = "SearchBarIsFirstResponderKey"
    }
    
    // State restoration values.
    struct SearchControllerRestorableState {
        var wasActive = false
        var wasFirstResponder = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getLocationsNearBy()
        self.setUpSearchResults()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        // restore the searchController's active state
        if self.restoredState.wasActive {
            self.searchController.active = self.restoredState.wasActive
            self.restoredState.wasActive = false
            
            if self.restoredState.wasFirstResponder {
                searchController.searchBar.becomeFirstResponder()
                self.restoredState.wasFirstResponder = false
            }
        }
    }
    
    func setUpSearchResults() {
    
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.searchController = UISearchController()
        self.resultsTableController = SearchTableViewController()
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        self.resultsTableController.tableView.delegate = self
        self.searchController.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        
        self.definesPresentationContext  = true
    }
    
    func getLocationsNearBy() {
    
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        var params = NSMutableDictionary(dictionary: ["geopoint": PFGeoPoint(latitude: 37.77355, longitude: -122.403309)])
        if self.queryName != nil {
            params["query"] = self.queryName
        }
        PFCloud.callFunctionInBackground("getNearbyLocations", withParameters: params, block: {
            (locations, err) in
            if err == nil {
                println("Locations are \(locations)")
                self.locationsArray = locations as [NSMutableDictionary]
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func navigateBack(sender: AnyObject) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        println("In function \(__FUNCTION__)")
        
        // includes 1px separator
        return 60
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return self.locationsArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Location", forIndexPath: indexPath) as UITableViewCell
        if let urlString = self.locationsArray[indexPath.item]["icon"] as? String {
            if let url = NSURL(string: urlString) {
                self.downloadImageWithURL(url, completion: {
                    (success, image) in
                    if success {
                        cell.imageView?.image = image
                        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
                    }
                })
            }
        }
        
        cell.textLabel?.text = self.locationsArray[indexPath.item]["name"] as? String
        if let address = self.locationsArray[indexPath.item]["address"] as? String {
            cell.detailTextLabel?.text = address
        } else if let locationDict = self.locationsArray[indexPath.item]["location"] as? NSMutableDictionary {
            cell.detailTextLabel?.text = locationDict["address"] as? String
        }
        println("Address is \(cell.detailTextLabel?.text)")

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        self.indexSelected = indexPath.item
        var query = PFQuery(className: "Location")
        query.getObjectInBackgroundWithId("6XwzjWZoaK", block: {
            (location, err) in
            var locationObj = location as PFObject
            locationObj["name"] = self.locationsArray[self.indexSelected]["name"] as? String
            locationObj.saveInBackgroundWithBlock(nil)
        })
        self.performSegueWithIdentifier("Set Time", sender: self)
    }
    
    func downloadImageWithURL(url: NSURL, completion: ((success: Bool, image: UIImage!) -> Void)) {
        var request = NSMutableURLRequest()
        request.URL = url
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response, data, error) in
            if error == nil {
                var image = UIImage(data: data)
                completion(success: true, image: image)
            } else {
                completion(success: false, image: nil)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        if segue.identifier == "Set Time" {
            var destController: SetTimeViewController = segue.destinationViewController as SetTimeViewController
            destController.locationSelected = self.locationsArray[self.indexSelected]["name"] as? String
            destController.queryName = self.queryName
        }
    }
}

extension LocationsTableViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        println("In function \(__FUNCTION__) in \(self.description) \n")
        
        searchBar.becomeFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // Update the filtered array based on the search text.
        let searchResults = self.locationsArray
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let strippedString = searchController.searchBar.text.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        let searchItems = strippedString.componentsSeparatedByString(" ") as [String]
        
        // Build all the "AND" expressions for each value in the searchString.
        var andMatchPredicates = [NSPredicate]()
        
        for searchString in searchItems {
            // Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
            //
            // Example if searchItems contains "iphone 599 2007":
            //      name CONTAINS[c] "iphone"
            //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
            //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
            //
            var searchItemsPredicate = [NSPredicate]()
            
            // Name field matching.
            var lhs = NSExpression(forKeyPath: "name")
            var rhs = NSExpression(forConstantValue: searchString)
            
            var finalPredicate = NSComparisonPredicate(leftExpression: lhs, rightExpression: rhs, modifier: .DirectPredicateModifier, type: .ContainsPredicateOperatorType, options: .CaseInsensitivePredicateOption)
            
            searchItemsPredicate.append(finalPredicate)
            
            // Add this OR predicate to our master AND predicate.
            let orMatchPredicates = NSCompoundPredicate.orPredicateWithSubpredicates(searchItemsPredicate)
            andMatchPredicates.append(orMatchPredicates)
        }
        
        // Match up the fields of the Product object.
        let finalCompoundPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(andMatchPredicates)
        
        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluateWithObject($0) }
        
        // Hand over the filtered results to our search results table.
        let resultsController = searchController.searchResultsController as SearchTableViewController
        resultsController.filteredResults = filteredResults
        resultsController.tableView.reloadData()
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        super.encodeRestorableStateWithCoder(coder)
        
        // Encode the title.
        coder.encodeObject(navigationItem.title, forKey:RestorationKeys.viewControllerTitle)
        
        // Encode the search controller's active state.
        coder.encodeBool(self.searchController.active, forKey:RestorationKeys.searchControllerIsActive)
        
        // Encode the first responser status.
        coder.encodeBool(self.searchController.searchBar.isFirstResponder(), forKey:RestorationKeys.searchBarIsFirstResponder)
        
        // Encode the search bar text.
        coder.encodeObject(self.searchController.searchBar.text, forKey:RestorationKeys.searchBarText)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        super.decodeRestorableStateWithCoder(coder)
        
        // Restore the title.
        if let decodedTitle = coder.decodeObjectForKey(RestorationKeys.viewControllerTitle) as? String {
            title = decodedTitle
        }
        else {
            fatalError("A title did not exist. In your app, handle this gracefully.")
        }
        
        // Restore the active state:
        // We can't make the searchController active here since it's not part of the view
        // hierarchy yet, instead we do it in viewWillAppear.
        //
        self.restoredState.wasActive = coder.decodeBoolForKey(RestorationKeys.searchControllerIsActive)
        
        // Restore the first responder status:
        // Like above, we can't make the searchController first responder here since it's not part of the view
        // hierarchy yet, instead we do it in viewWillAppear.
        //
        self.restoredState.wasFirstResponder = coder.decodeBoolForKey(RestorationKeys.searchBarIsFirstResponder)
        
        // Restore the text in the search field.
        self.searchController.searchBar.text = coder.decodeObjectForKey(RestorationKeys.searchBarText) as String
    }
}

