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
    
    struct columns {
        let id = Expression<Int64>("id")
        let startTime = Expression<Date>("start_time")
        let duration = Expression<Int64>("duration")
        let info = Expression<String?>("info")
        let category = Expression<String?>("category")
    }
    
    func initDB() {
        
        if (nil == self.times) {
            createTable()
        }
    }
    
    func createTable() {
        let times = Table("times")
//        let id = Expression<Int64>("id")
//        let startTime = Expression<Date>("start_time")
//        let duration = Expression<Int64>("duration")
//        let info = Expression<String?>("info")
        
        
        try! db.run(times.create {t in
            t.column(columns.id, primaryKey: true)
            t.column(columns.startTime)
            t.column(columns.duration)
            t.column(columns.info)
        })
    }
    
    func insertData(startTime: Date, duration: Int64, info: String) {
        if (nil == times) {
            createTable()
        }
        
        let insert = times.insert(columns.startTime <- startTime, columns.duration <- duration, columns.info <- info)
        // insert time duration
    }
    
    func getTimes() {
        
        
        //get all times from db
    }
    
}
