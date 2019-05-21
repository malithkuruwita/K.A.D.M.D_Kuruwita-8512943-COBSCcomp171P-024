//
//  MyProfile.swift
//  NIBMConnect
//
//  Created by malith on 5/21/19.
//  Copyright © 2019 malith. All rights reserved.
//

import Foundation
import Firebase

class MyProfile{
    
    var age: String
    var name: String
    var birthdate: String
    var phoneNumber: String
    var photoURL: URL
    
    init(snap: DataSnapshot) {
        let profileDict = snap.value as! [String: Any]
        
        self.age = profileDict["age"] as! String
        self.name = profileDict["name"] as! String
        self.birthdate = profileDict["birthdate"] as! String
        self.phoneNumber = profileDict["phoneNumber"] as! String
        self.photoURL = NSURL(string: (profileDict["photoURL"] as? String ?? "no image")!)! as URL
    }
    
    
}
