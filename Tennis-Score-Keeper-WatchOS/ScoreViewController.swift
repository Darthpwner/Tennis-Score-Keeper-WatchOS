//
//  ViewController.swift
//  Tennis-Score-Keeper-WatchOS
//
//  Created by Matthew Allen Lin on 7/3/17.
//  Copyright © 2017 Matthew Allen Lin Software. All rights reserved.
//

import UIKit
import WatchConnectivity    //To have iOS app and Watch app talk to each other

class ScoreViewController: UIViewController, WCSessionDelegate {    
    
    // Starts a session to communicate with the Watch app
    var session: WCSession!
    
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
    
    //Sharing Data
//    var sharedFilePath: String?
//    var sharedDefaults: UserDefaults?
//    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("iOS: WCSession.isSupported(): \(WCSession.isSupported())")
        if(WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
            
            print("session.activate(): \(session.activate)")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // For WCSession
    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        print("SESSION: \(session)")
//        print("ACTIVATION_STATE: \(activationState)")
//        print("ERROR: \(error)")
    }
    
    // Receives data from Watch app
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("applicationContext: \(applicationContext)")
        
        print("applicationContext[player_1_game_score_label]: \(String(describing: applicationContext["player_1_game_score_label"]))")
        
        let player_1_game_score_label = applicationContext["player_1_game_score_label"]
        let player_2_game_score_label = applicationContext["player_2_game_score_label"]
        print("FUCK")
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        DispatchQueue.main.async() {
        print("player_1_game_score_label: \(String(describing: player_1_game_score_label))")
            self.player_1_game_score_label.text = ("\(String(describing: player_1_game_score_label))")
            print("player_2_game_score_label: \(String(describing: player_2_game_score_label))")
            self.player_2_game_score_label.text = ("\(String(describing: player_2_game_score_label))")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive session: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Begin the activation process for the new Apple Watch.
        print("sessionDidDeactivate session: \(session)")
        WCSession.default().activate()
    }

}

