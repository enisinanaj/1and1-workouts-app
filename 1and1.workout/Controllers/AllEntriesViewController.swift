//
//  AllEntriesViewController.swift
//  microtime.tracker
//
//  Created by Eni Sinanaj on 29/10/2016.
//  Copyright © 2016 Eni Sinanaj. All rights reserved.
//

import UIKit
import SQLite

class AllEntriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hintText: UILabel!
    
    var hintIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "TimeTableViewCell", bundle: nil) , forCellReuseIdentifier: "timeCell")
        tableView.tableFooterView = UIView(frame: .zero)
        
        startHintAnimations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startHintAnimations() {
        self.hintText.text = getNewHint()
        
        // Fade out to set the text
        UIView.animate(withDuration: 1.5, delay: 1.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.hintText.alpha = 1.0
        }, completion: {
            (finished: Bool) -> Void in
            UIView.animate(withDuration: 1.5, delay: 2.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.hintText.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                self.startHintAnimations()
            })
        })
    }
    
    func getNewHint() -> String {
        hintIndex = hintIndex + 1
        if (hintIndex == 1) {
            return "Shake to delete all entries"
        } else if (hintIndex == 2) {
            hintIndex = 0 // reset hintIndex
            return "Swipe right to start a new section"
        }
        
        return ""
    }

}

extension AllEntriesViewController: UITableViewDelegate {
    func reloadData() {
        DispatchQueue.main.async() {
            print("reloading tableview data")
            self.tableView.reloadData()
        }
    }
}


extension AllEntriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sql = SQLiteProxy()
        sql.initDB()
        
        return sql.getRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as? TimeTableViewCell else {
            
            return UITableViewCell()
        }
    
        // TODO: get data from local database
        tableViewCell.id = Int64(indexPath.row)
        tableViewCell.populate()
        return tableViewCell
    }
}
