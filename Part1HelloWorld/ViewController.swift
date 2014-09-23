//
//  ViewController.swift
//  Part1HelloWorld
//
//  Created by Austin Truong on 9/16/14.
//  Copyright (c) 2014 Crowd Control. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var appsTableView : UITableView?
    
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchForTunes("Facebook")
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

    func searchForTunes(searchTerm: String){
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        if let escapeSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding){
            let urlPath = "http://itunes.apple.com/search?term=\(escapeSearchTerm)&media=software"
            let url : NSURL = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
                println("Task Completed")
                if (error != nil){
                    println(error.localizedDescription)
                }
                var err: NSError?
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary

                if (err != nil){
                    // If error pass to json
                    println("JSON Error \(err!.localizedDescription)")
                }
                let results: NSArray = jsonResult["results"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData = results
                    self.appsTableView!.reloadData()
                })
            })
            task.resume()
        }
    }

}

