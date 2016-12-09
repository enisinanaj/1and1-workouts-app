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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "TimeTableViewCell", bundle: nil) , forCellReuseIdentifier: "timeCell")
        
        // no lines where there aren't cells
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
