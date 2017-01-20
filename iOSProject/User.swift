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
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
