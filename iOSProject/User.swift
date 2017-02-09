//
//  User.swift
//  iOSProject
//
//  Created by クリス on 2017/01/21.
//  Copyright © 2017年 SystemStudio. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    let id: String
    
    init(authData: FIRUser) {
        id = authData.providerID
        uid = authData.uid
        email = authData.email!
    }
    
    init(id: String, uid: String, email: String) {
        self.id = id
        self.uid = uid
        self.email = email
    }
    
}
