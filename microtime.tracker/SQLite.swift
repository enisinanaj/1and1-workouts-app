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
    var db: Connection? = nil
    var times: Table? = nil
    
    let id = Expression<Int64>("id")
    let startTime = Expression<String>("start_time")
    let duration = Expression<Int64>("duration")
    let info = Expression<String?>("info")
    let category = Expression<String?>("category")
    
    func initDB() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        db = try! Connection("\(path)/db.sqlite3")
        
        if (nil == self.times) {
            createTable()
        }
    }
    
    func createTable() {
        let times = Table("times")
        
        try! db!.run(times.create(ifNotExists: true) {t in
            t.column(id, primaryKey: .autoincrement)
            t.column(startTime)
            t.column(duration)
            t.column(info)
            t.column(category)
        })
        
    }
    
    func insertData(startTime: String, duration: Int64, info: String, category: String) -> Int64 {
        if (nil == self.times) {
            createTable()
        }
        
        let times = Table("times")
        
        // insert time duration
        let insert = times.insert(self.startTime <- startTime, self.duration <- duration, self.info <- info, self.category <- category)
        
        return try! db!.run(insert)
    }
    
    func getTimes() -> Array<Row> {
        let times = Table("times")
        
        let result = try! db!.prepare(times)
        
        return Array(result)
        //get all times from db
    }
    
    func getTimeByID(filterId: Int64) -> Row {
        let times = Table("times")
        let query = times.filter(id == filterId)
        let result = try! db!.pluck(query)
        
        return result!
    }
    
    func getRowCount() -> Int {
        let times = Table("times")
        
        return 2 //try! db!.scalar(times.count)
    }
    
    func deleteRow(id: Int64) {
        let times = Table("times")
        let row = times.filter(self.id == id)
        _ = try! db!.run(row.delete())
    }
}
