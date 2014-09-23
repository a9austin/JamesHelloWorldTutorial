//
//  SearchResultsViewController.swift
//  Part1HelloWorld
//
//  Created by Austin Truong on 9/16/14.
//  Copyright (c) 2014 Crowd Control. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol{

    @IBOutlet var appsTableView : UITableView?
    var api = APIController()
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.searchForTunes("Angry Birds")
        api.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        cell.textLabel?.text = rowData["trackName"] as? String
        
        // Grab the artwork URL
        let urlString: NSString = rowData["artworkUrl60"] as NSString
        let imgUrl: NSURL = NSURL(string: urlString)
        
        // Download NSData representation of the image URL
        let imgData: NSData = NSData(contentsOfURL: imgUrl)
        cell.imageView?.image = UIImage(data: imgData)
        
        // Get the formatted path price string for display in the subtitle
        let formattedPrice: NSString = rowData["formattedPrice"] as NSString
        
        cell.detailTextLabel?.text = formattedPrice
        
        return cell
    }
    
    func didRecieveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(),{
            self.tableData = resultsArr
            self.appsTableView!.reloadData()
        })
    }

}

