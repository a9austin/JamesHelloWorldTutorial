//
//  APIController.swift
//  Part1HelloWorld
//
//  Created by Austin Truong on 9/22/14.
//  Copyright (c) 2014 Crowd Control. All rights reserved.
//

import Foundation


protocol APIControllerProtocol{
    func didRecieveAPIResults(results: NSDictionary)
}

class APIController{
    var delegate: APIControllerProtocol
    
    init(delegate: APIControllerProtocol){
        self.delegate = delegate
    }
    
    func searchForTunes(searchTerm: String){
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        if let escapeSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding){
            let urlPath = "http://itunes.apple.com/search?term=\(escapeSearchTerm)&media=music&entity=album"
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
                self.delegate.didRecieveAPIResults(jsonResult)
            })
            task.resume()
        }
    }  
}
