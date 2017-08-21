//
//  NotificationViewController.swift
//  microtime.tracker
//
//  Created by Eni Sinanaj on 05/12/2016.
//  Copyright © 2016 Eni Sinanaj. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var notificationLabel: UILabel!
    var notificationText: String!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 15
        self.notificationLabel.text = notificationText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
