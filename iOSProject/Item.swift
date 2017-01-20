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
    
    init(word: String, addedByUser: String, meaning: String, completed: Bool, key: String = "") {
        self.key = key
        self.word = word
        self.addedByUser = addedByUser
        self.meaning = meaning
        self.completed = completed
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        word = snapshotValue["word"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        meaning = snapshotValue["meaning"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "word": word,
            "addedByUser": addedByUser,
            "meaning": meaning,
            "completed": completed
        ]
    }
    
}
