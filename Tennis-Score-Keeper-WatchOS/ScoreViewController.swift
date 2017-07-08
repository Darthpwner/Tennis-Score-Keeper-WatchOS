//
//  ViewController.swift
//  Tennis-Score-Keeper-WatchOS
//
//  Created by Matthew Allen Lin on 7/3/17.
//  Copyright © 2017 Matthew Allen Lin Software. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {

//    var sharedFilePath: String?
//    var shared

    //Outlets
    //Set Score Outlets
    @IBOutlet weak var player_1_set_1_score_label: UILabel!
    @IBOutlet weak var set_1_dash_label: UILabel!
    @IBOutlet weak var player_2_set_1_score_label: UILabel!
    
    @IBOutlet weak var player_1_set_2_score_label: UILabel!
    @IBOutlet weak var set_2_dash_label: UILabel!
    @IBOutlet weak var player_2_set_2_score_label: UILabel!
    
    @IBOutlet weak var player_1_set_3_score_label: UILabel!
    @IBOutlet weak var set_3_dash_label: UILabel!
    @IBOutlet weak var player_2_set_3_score_label: UILabel!
    
    //Game Score Outlets
    @IBOutlet weak var player_1_serving_image: UIImageView!
    @IBOutlet weak var player_1_game_score_label: UILabel!
    @IBOutlet weak var game_score_dash_label: UILabel!
    @IBOutlet weak var player_2_game_score_label: UILabel!
    @IBOutlet weak var player_2_serving_image: UIImageView!
    
    //Player Outlets
    @IBOutlet weak var player_1_label: UILabel!
    @IBOutlet weak var player_2_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

