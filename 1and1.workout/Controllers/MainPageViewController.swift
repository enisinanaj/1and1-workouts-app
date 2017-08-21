//
//  MainPageViewController.swift
//  microtime.tracker
//
//  Created by Eni Sinanaj on 29/10/2016.
//  Copyright © 2016 Eni Sinanaj. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class MainPageViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var viewDescriptionLabel: UILabel!
    @IBOutlet weak var completedExercise: UIButton!
    
    weak var allEntriesDelegate: AllEntriesViewController?
    var counterViewController: CounterViewController = CounterViewController(nibName: "CounterViewController", bundle: nil)
    var parentController: ViewController?
    var exercise: Exercise?
    
    var running: Bool!
    var introText: String = "When the minute is reached, take one minute of rest, then swipe left to proceede with the next exercise"
    
    @IBAction func startTimerAction(_ sender: AnyObject) {
        startButton.isHidden = true
        
        counterViewController.modalPresentationStyle = .overCurrentContext
        self.present(counterViewController, animated: true, completion: nil)
        
        counterViewController.startTime(sender)
        counterViewController.parentController = self
    }
    
    func completeExercise(_ wasRunning: Bool) {
        self.startButton.isHidden = true
        self.completedExercise.isHidden = false
        
        let sql = SQLiteProxy();
        
        let time = counterViewController.sectionSeconds
        let tuple = counterViewController.secondsToTimeString(NSInteger(time))
        let seconds = String(tuple.seconds)
        let minutes = String(tuple.minutes)
        
        let timeAsText = (minutes).appending("M ").appending(seconds).appending("S")
        
        print("timeAsText: " + timeAsText)
        print("int64Time: " + String(time))
        
        if !wasRunning {
            sql.initDB();
            let _ = sql.insertData(startTime: timeAsText, duration: Int64(time), info: (exercise?.title)!, category: (exercise?.description)!);
        }
        
        allEntriesDelegate?.reloadData();
        
        self.dismiss(animated: true, completion:  nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.viewDescriptionLabel.sizeToFit()
        self.completedExercise.isHidden = true
        
        print("")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateData() {
        self.viewTitle.text = exercise?.title
        self.viewDescriptionLabel.text = (exercise?.description)! + "\n\n" + self.introText
        self.viewDescriptionLabel.sizeToFit()
        self.viewDescriptionLabel.textAlignment = .justified
        self.startButton.isHidden = false
        self.completedExercise.isHidden = true
        
        counterViewController.minutes = 0
        counterViewController.seconds = 0
        
        counterViewController.timeKeeper = 0.0
        counterViewController.startSeconds = 0.0
        counterViewController.sectionSeconds = 0.0
        counterViewController.differenceInSecconds = 0.0
    }

}
