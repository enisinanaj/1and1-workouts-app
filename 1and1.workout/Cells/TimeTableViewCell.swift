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
    
    var rows: [Row] = []
    
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
    
    func getRow(at index: Int64) -> Row? {
        var i: Int64 = 0
        
        for r in rows {
            if (i == index) {
                return r
            } else {
                i += 1
            }
        }
        
        return nil
    }
    
    func populate(forSection: String) {
        if rows.count == 0 {
            let sql = SQLiteProxy()
            rows = sql.getRows(forSection: forSection)
        }
        
        let startTime = Expression<String>("start_time")
        let category = Expression<String?>("category")
        let description = Expression<String?>("info")
        let idExpression = Expression<Int64?>("id")
        
        let row = getRow(at: self.id)
        self.subject.text = row!.get(category)
        self.date.text = row!.get(startTime)
        self.timeLabel.text = row!.get(description)
        self.id = row!.get(idExpression)!
    }
    
}
