//
//  TimeTableViewCell.swift
//  microtime.tracker
//
//  Created by Andy Miller on 13/11/2016.
//  Copyright © 2016 Eni Sinanaj. All rights reserved.
//

import UIKit
import SQLite

class TimeTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var date: UILabel!
    var id: Int64 = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization 
        self.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        self.backgroundView = UIView();
        self.selectedBackgroundView = UIView();
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(forSection: String) {
        let sql = SQLiteProxy()
        sql.initDB()
        
        let startTime = Expression<String>("start_time")
        let category = Expression<String?>("category")
        let description = Expression<String?>("info")
        
        let row: Row? = sql.getTimeByID(filterId: self.id);
        self.subject.text = row!.get(category)
        self.date.text = row!.get(startTime)
        self.timeLabel.text = row!.get(description)
    }
    
}
