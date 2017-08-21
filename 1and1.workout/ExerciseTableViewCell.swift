//
//  ExerciseTableViewCell.swift
//  1and1.workout
//
//  Created by Eni Sinanaj on 16/08/2017.
//  Copyright © 2017 Eni Sinanaj. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization
        self.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        self.backgroundView = UIView()
        self.selectedBackgroundView = UIView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var exercisePreview: UIImageView!
    @IBOutlet weak var exerciseTitle: UILabel!
    @IBOutlet weak var exerciseDescription: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    
    var exerciseId: Int!
}
