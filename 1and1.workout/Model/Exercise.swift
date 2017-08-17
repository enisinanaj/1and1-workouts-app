//
//  Exercise.swift
//  1and1.workout
//
//  Created by Eni Sinanaj on 17/08/2017.
//  Copyright © 2017 Eni Sinanaj. All rights reserved.
//

import UIKit

class Exercise {
    
    static var lastId = 0
    
    var id = 0
    var title: String
    var description: String
    var image: UIImage
    var duration: Double
    var restDuration: Double
    
    
    init(_ title: String, description: String, image: UIImage, duration: Double, restDuration: Double) {
        self.title = title
        self.description = description
        self.image = image
        self.duration = duration
        self.restDuration = restDuration
        
        self.id = Exercise.lastId
        Exercise.lastId = self.id + 1
    }
}
