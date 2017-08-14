//
//  ExercisesTableTableViewController.swift
//  1and1.workout
//
//  Created by Eni Sinanaj on 14/08/2017.
//  Copyright © 2017 Eni Sinanaj. All rights reserved.
//

import UIKit

class ExercisesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        return UITableViewCell(frame: self.view.frame)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame.size.width = self.view.frame.width
        headerView.frame.size.height = 170
        headerView.backgroundColor = UIColor(red:0.35, green:0.67, blue:0.89, alpha:1.0)
        
        let title = UILabel()
        title.text = "Select an exercise below"
        title.frame.size.width = headerView.frame.width - 20
        title.frame.origin.x = headerView.frame.origin.x + 10
        title.frame.origin.y = headerView.frame.origin.y + 10
        title.numberOfLines = 0
        
        let fontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptorFamilyAttribute: "Helvetica Neue",
                                                               UIFontDescriptorSizeAttribute: 37.0,
                                                               UIFontDescriptorTraitsAttribute:
                                                                [UIFontWeightTrait: UIFontWeightThin]])
        
        title.font = UIFont(descriptor: fontDescriptor, size: 29.0)
        title.textColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        
        headerView.addSubview(title)
        
        title.sizeToFit()
        
        return headerView
    }
}
