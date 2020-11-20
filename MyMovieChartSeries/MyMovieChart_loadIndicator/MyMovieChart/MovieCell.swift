//
//  MovieCell.swift
//  MyMovieChart
//
//  Created by 조상호 on 2020/10/20.
//  Copyright © 2020 조상호. All rights reserved.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    
    @IBOutlet var opendate: UILabel!
    
    @IBOutlet var desc: UILabel!
    
    @IBOutlet var rating: UILabel!
    
    @IBOutlet var thumbnail: UIImageView!
}
