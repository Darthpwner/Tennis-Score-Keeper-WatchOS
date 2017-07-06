//
//  Metadata.swift
//  Tennis-Score-Keeper-WatchOS
//
//  Created by Matthew Allen Lin on 7/6/17.
//  Copyright © 2017 Matthew Allen Lin Software. All rights reserved.
//

import Foundation

class Metadata {
    //0 means 1 set, 1 means best of 3 sets
    //Default value is 1
    var match_length = 1
    
    //0 means they will play a 10 point tiebreaker for the final set, 1 means they will NOT play a 10 point tiebreaker for the final set
    //Default value is 1
    var ten_point_tiebreaker_format = 1
    
    init (match_length_parameter: Int, ten_point_tiebreaker_format_parameter: Int) {
        match_length = match_length_parameter
        ten_point_tiebreaker_format = ten_point_tiebreaker_format_parameter
    }
    
}
