//
//  MainPageViewController.swift
//  microtime.tracker
//
//  Created by Eni Sinanaj on 29/10/2016.
//  Copyright © 2016 Eni Sinanaj. All rights reserved.
//

import UIKit
import AVFoundation

class MainPageViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var minutesHand: UILabel!
    @IBOutlet weak var secondsHand: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var minutes = 0
    var seconds = 0
    var hours = 0
    var timer: Timer!
    
    var startSeconds: Double = 0.0
    var sectionSeconds: Double = 0.0
    
    var running: Bool!
    
    func startTime(_ sender: AnyObject) {
        running = true
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        self.startSeconds = CACurrentMediaTime()
        
        startButton.isHidden = true
        stopButton.isHidden = false
    }
    
    func stopTime(_ sender: AnyObject) {
        timer.invalidate()
        running = false
        
        let saveEntryDialog = SaveEntryViewController(nibName: "SaveEntryViewController", bundle: nil)
        saveEntryDialog.time = sectionSeconds
        saveEntryDialog.timeAsText = (timeLabel!.text  ?? "").appending("H ")
                .appending(minutesHand!.text  ?? "").appending("M ")
                .appending(secondsHand?.text ?? "").appending("S")
            
        minutes = 0
        seconds = 0
        hours = 0
        timeLabel.text = "00"
        minutesHand.text = "00"
        secondsHand.text = "00"
        
        sectionSeconds = getIntervalFromStartTime()
        
        self.present(saveEntryDialog, animated: true, completion: nil)
        
        stopButton.isHidden = true
        startButton.isHidden = false
    }
    
    @IBAction func stopTimerAction(_ sender: AnyObject) {
        stopTime(sender)
    }
    
    @IBAction func startTimerAction(_ sender: AnyObject) {
        startTime(sender)
    }
    
    func update() {
        incrementSeconds()
        playBeep()
        timeLabel.text = getAsString(timePart: hours)
        minutesHand.text = getAsString(timePart: minutes)
        secondsHand.text = getAsString(timePart: seconds)
    }
    
    func playBeep() {
        let interval: Double = getIntervalFromStartTime()
        
        print("interval in seconds: " + String(interval))
        
        if (interval == 5) {
            //TODO: play notification aufio every half an hour?
        }
    }
    
    func getIntervalFromStartTime() -> Double {
        return CACurrentMediaTime() - startSeconds
    }
    
    func prepareBeepAudio() {
//        let path = Bundle.main.path(forResource: "notification", ofType: "mp3")
//        
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
//            //(contentsOf: URL(fileURLWithPath: path!), error: nil)
//            audioPlayer.prepareToPlay()
//        } catch {
//            print(error)
//        }
    }
    
    func incrementMinutes() {
        if (minutes == 59) {
            minutes = 0
            incrementHours()
        } else {
            minutes += 1
        }
    }
    
    func incrementHours() {
        if (hours == 23) {
            hours = 0
        } else {
            hours += 1
        }
    }
    
    func incrementSeconds() {
        if (seconds == 59) {
            seconds = 0
            incrementMinutes()
        } else {
            seconds += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isHidden = true
        prepareBeepAudio()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAsString(timePart: NSInteger) -> String {
        if (timePart == 0) {
            return "00"
        } else if (timePart > 0 && timePart < 10) {
            return "0" + String(timePart)
        } else {
            return String(timePart)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}