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
    let date = Expression<String?>("date")
    
    init() {
        initDB()
    }
    
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
            t.column(date)
        })
    }
    
    func insertData(startTime: String, duration: Int64, info: String, category: String) -> Int64 {
        if (nil == self.times) {
            createTable()
        }
        
        let times = Table("times")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        let date = dateFormatter.string(from: Date())
        
        // insert time duration
        let insert = times.insert(self.startTime <- startTime,
                                  self.duration <- duration,
                                  self.info <- info,
                                  self.category <- category,
                                  self.date <- date)
        
        return try! db!.run(insert)
    }
    
    func getTimes() -> Array<Row> {
        let times = Table("times")
        let result = try! db!.prepare(times)
        
        return Array(result)
    }
    
    func getTimeByID(filterId: Int64) -> Row? {
        let times = Table("times")
        let query = times.filter(id == filterId + 1)
        let result = try! db!.pluck(query)
        
        return result
    }
    
    func insertDummy() {
        if (nil == self.times) {
            createTable()
        }
        
        let times = Table("times")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        
        let dateFromString = dateFormatter.date(from: "20 Aug 2017")
        let date = dateFormatter.string(from: dateFromString!)
        
        // insert time duration
        let insert = times.insert(self.startTime <- "01M 30S",
                                  self.duration <- 60,
                                  self.info <- "INFO HERE",
                                  self.category <- "IS THIS A CAT",
                                  self.date <- date)
        
        try! db!.run(insert)
    }
    
    func getSections() -> Array<Row>? {
        let times = Table("times")
        let query = times.group(date).order(self.id .desc)
        let result = try! db!.prepare(query)
        
        return Array(result)
    }
    
    func getRows(forSection: String) -> Array<Row> {
        let times = Table("times")
        let query = times.filter(date == forSection).order(self.id .desc)
        let result = try! db!.prepare(query)
        
        return Array(result)
    }
    
    func deleteRow(id: Int64) {
        let times = Table("times")
        let row = times.filter(self.id == id)
        _ = try! db!.run(row.delete())
    }
    
    func deleteAllRows() {
        let times = Table("times")
        _ = try! db!.run(times.drop(ifExists: true))
        self.times = nil
    }
}
