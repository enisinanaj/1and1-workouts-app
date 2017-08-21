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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sql = SQLiteProxy()
        let sections = sql.getSections()
        
        return sections != nil ? sections!.count : 0
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let sql = SQLiteProxy()
        let sections = sql.getSections()
        var result: [String] = []
        
        if sections == nil {
            return nil
        }
        
        for r in sections! {
            result.append(r.get(sql.date)!)
        }
        
        return result
    }
}


extension AllEntriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sql = SQLiteProxy()
        return sql.getRowCount()
    }
    
    func getSectionKeys() -> [String]? {
        let sql = SQLiteProxy()
        let sections = sql.getSections()
        var result: [String] = []
        
        if sections == nil {
            return nil
        }
        
        for r in sections! {
            result.append(r.get(sql.date)!)
        }
        
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as? TimeTableViewCell else {
            
            return UITableViewCell()
        }

        let sections = getSectionKeys()
    
        tableViewCell.id = Int64(indexPath.row)
        tableViewCell.populate(forSection: sections![indexPath.section])
        return tableViewCell
    }
}
