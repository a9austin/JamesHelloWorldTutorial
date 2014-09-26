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
    var imageCache = [String : UIImage]()
    var api: APIController?
    var albums = [Album]()
    let kCellIdentifier: String = "SearchResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.searchForTunes("Beatles")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
        var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
        var selectedAlbum = self.albums[albumIndex]
        detailsViewController.album = selectedAlbum
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        let album = self.albums[indexPath.row]
        
        cell.textLabel?.text = album.title
        cell.imageView?.image = UIImage(named: "Blank52.jpeg")
        
        // Grab the artwork URL
        let urlString: NSString = album.thumbnailImageURL
        // Get the formatted path price string for display in the subtitle
        let formattedPrice = album.price
        var image = self.imageCache[urlString]
        
        if (image == nil){
            // If image does not exist download it
            let imgUrl: NSURL = NSURL(string: urlString)
            let request: NSURLRequest = NSURLRequest(URL: imgUrl)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if error == nil{
                    image = UIImage(data: data)
                    
                    self.imageCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath){
                            cellToUpdate.imageView?.image = image
                        }
                    })
                }
                else{
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        else{
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath){
                    cellToUpdate.imageView?.image = image
                }
            })
        }
        
        cell.detailTextLabel?.text = formattedPrice
        
        return cell
    }
    
    func didRecieveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(),{
            self.albums = Album.albumsWithJSON(resultsArr)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }

}

