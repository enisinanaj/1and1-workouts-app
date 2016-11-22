//
//  SQLite.swift
//  microtime.tracker
//
//  Created by Andy Miller on 20/11/2016.
//  Copyright © 2016 Eni Sinanaj. All rights reserved.
//

import Foundation
import SQLite

class SQLiteProxy {
    let db = try! Connection("myDB")
    var times: Table? = nil
    
    func initDB() {
        
        if (nil == self.times) {
            createTable()
        }
    }
    
    func createTable() {
        let times = Table("times")
        let id = Expression<Int64>("id")
        let startTime = Expression<Date>("start_time")
        let duration = Expression<Int64>("duration")
        let info = Expression<String?>("info")
        
        try! db.run(times.create {t in
            t.column(id, primaryKey: true)
            t.column(startTime)
            t.column(duration)
            t.column(info)
        })
    }
    
    func insertData() {
        if (nil == times) {
            createTable()
        }
        
        // insert time duration
    }
    
    func getTimes() {
        
        
        //get all times from db
    }
    
}
