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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame.size.width = self.view.frame.width
        headerView.frame.size.height = tableView.sectionHeaderHeight
        headerView.frame.origin.x = 0
        headerView.frame.origin.y = 0
        headerView.backgroundColor = UIColor.white //(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        
        let title = UILabel()
        title.text = getSectionTitle(section)
        title.textColor = UIColor.black
        title.frame.origin.x = 10
        title.frame.origin.y = 5
        title.frame.size.width = self.view.frame.width - 120
        title.frame.size.height = tableView.sectionHeaderHeight - 5
        title.font = UIFont(name: "HelveticaNeue", size: 16)
        
        let editButton = ClearSectionUIButton()
        editButton.setTitle("Clear", for: .normal)
        editButton.frame.origin.x = self.view.frame.width - 100
        editButton.frame.origin.y = 10
        editButton.frame.size.width = 70
        editButton.frame.size.height = 20
        editButton.backgroundColor = UIColor.white.withAlphaComponent(0)
        editButton.setTitleColor(UIColor.red, for: .normal)
        editButton.showsTouchWhenHighlighted = true
        editButton.sectionName = title.text
        editButton.isEnabled = true
        editButton.addTarget(self, action: #selector(self.sectionEditButtonPressed(_:)), for: .touchUpInside)
        
        headerView.addSubview(editButton)
        headerView.addSubview(title)
        
        return headerView
    }
    
    @objc func sectionEditButtonPressed(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Clear",
                                             message: "All exercises stored for this date will be removed!",
                                             preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let sql = SQLiteProxy()
            sql.deleteRows(forSection: (sender as! ClearSectionUIButton).sectionName!)
            self.tableView.reloadData()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.frame.size.width = self.view.frame.width
        footerView.frame.size.height = tableView.sectionFooterHeight
        footerView.frame.origin.x = 0
        footerView.frame.origin.y = 0
        footerView.backgroundColor = UIColor.white
        
        return footerView
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .delete {
            print("delete")
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    func getSectionTitle(_ section: Int) -> String? {
        let sql = SQLiteProxy()
        let sections = sql.getSections()
        var result: [String] = []
        
        if sections == nil {
            return nil
        }
        
        for r in sections! {
            do {
                try result.append(r.get(sql.date)!)
            } catch {
                
            }
        }
        
        return result[section]
    }
}


extension AllEntriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sql = SQLiteProxy()
        let sections = getSectionKeys()
        let rows = sql.getRows(forSection: sections![section])
      
        return rows.count
    }
    
    func getSectionKeys() -> [String]? {
        let sql = SQLiteProxy()
        let sections = sql.getSections()
        var result: [String] = []
        
        if sections == nil {
            return nil
        }
        
        for r in sections! {
            do {
                try result.append(r.get(sql.date)!)
            } catch {
                
            }
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
