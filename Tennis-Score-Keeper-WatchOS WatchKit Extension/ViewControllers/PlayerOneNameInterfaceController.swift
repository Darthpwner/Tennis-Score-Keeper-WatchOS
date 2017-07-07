//
//  PlayerOneNameInterfaceController.swift
//  Tennis-Score-Keeper-WatchOS
//
//  Created by Matthew Allen Lin on 7/7/17.
//  Copyright © 2017 Matthew Allen Lin Software. All rights reserved.
//

import WatchKit
import Foundation


class PlayerOneNameInterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.presentTextInputController(withSuggestions: ["suggestion 1", "suggestion 2"], allowedInputMode: .plain, completion: { (answers) -> Void in
            
                if let answer = answers?[0] as? String {
                    print("\(answer)")
                }
            
        })
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
