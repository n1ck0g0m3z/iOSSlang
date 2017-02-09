//
//  Item.swift
//  iOSProject
//
//  Created by クリス on 2017/01/21.
//  Copyright © 2017年 SystemStudio. All rights reserved.
//

import Foundation
import Firebase

struct Item {
    
    let key: String
    let word: String
    let addedByUser: String
    let meaning: String
    let ref: FIRDatabaseReference?
    var completed: Bool
    let starCount: Int
    let uid: String
    
    init(word: String, addedByUser: String, meaning: String, completed: Bool, starCount: Int, uid: String,key: String = "") {
        self.key = key
        self.word = word
        self.addedByUser = addedByUser
        self.meaning = meaning
        self.completed = completed
        self.starCount = starCount
        self.uid = uid
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        word = snapshotValue["title"] as! String
        addedByUser = snapshotValue["author"] as! String
        meaning = snapshotValue["body"] as! String
        completed = snapshotValue["completed"] as! Bool
        starCount = snapshotValue["starCount"] as! Int
        uid = snapshotValue["uid"] as! String
        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": word,
            "author": addedByUser,
            "body": meaning,
            "completed": completed,
            "starCount": starCount,
            "uid": uid
        ]
    }
    
}
