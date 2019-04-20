//
//  ExerciseTableViewCell.swift
//  1and1.workout
//
//  Created by Eni Sinanaj on 16/08/2017.
//  Copyright © 2017 Eni Sinanaj. All rights reserved.
//

import UIKit
import pop

class ExerciseTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization
        self.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        self.backgroundView = UIView()
        self.selectedBackgroundView = UIView()
    }
    
    @IBOutlet weak var cardView: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func viewPressed() {
        let springAnimation = POPSpringAnimation(propertyNamed: kPOPLayerSize)
        springAnimation?.toValue = NSValue(cgSize: CGSize(width: self.layer.visibleRect.width - 50, height: self.layer.visibleRect.height - 50))
        springAnimation?.springBounciness = CGFloat(20)
        springAnimation?.delegate = self
        springAnimation?.name = "POPLayerSize"
        self.layer.pop_add(springAnimation, forKey: "POPLayerSize")
    }
    
    @IBOutlet weak var exercisePreview: UIImageView!
    @IBOutlet weak var exerciseTitle: UILabel!
    @IBOutlet weak var exerciseDescription: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    
    var exerciseId: Int!
}
