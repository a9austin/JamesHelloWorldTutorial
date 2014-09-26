//
//  DetailsViewController.swift
//  Part1HelloWorld
//
//  Created by Austin Truong on 9/25/14.
//  Copyright (c) 2014 Crowd Control. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController{
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var album: Album?
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)))
    }
}