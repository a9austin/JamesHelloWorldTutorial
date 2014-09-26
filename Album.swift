//
//  Album.swift
//  Part1HelloWorld
//
//  Created by Austin Truong on 9/24/14.
//  Copyright (c) 2014 Crowd Control. All rights reserved.
//

import Foundation

class Album{
    var title: String
    var price: String
    var thumbnailImageURL: String
    var largeImageURL: String
    var itemURL: String
    var artistURL: String
    
    init(title: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String){
        self.title = title
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
    }
    
    class func albumsWithJSON(allResults: NSArray) -> [Album] {
        var albums = [Album]()
        
        if allResults.count>0 {
            for result in allResults {
                var name = result["trackName"] as? String
                if name == nil {
                    // Check collection and name
                    name = result["collectionName"] as? String
                }
                
                var price = result["formattedPrice"] as? String
                if price == nil{
                    price == result["collectionPrice"] as? String
                    if price == nil {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$"+nf.stringFromNumber(priceFloat!)
                        }
                    }
                }
                
                let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil{
                    itemURL = result["trackViewUrl"] as? String
                }
                
                var newAlbum = Album(title: name!, price: price!, thumbnailImageURL: thumbnailURL, largeImageURL: imageURL, itemURL: itemURL!, artistURL: artistURL)
                albums.append(newAlbum)
            }
        }
        return albums;
    }
}