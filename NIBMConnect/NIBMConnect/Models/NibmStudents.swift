//
//  nibmStudents.swift
//  NIBMConnect
//
//  Created by malith on 5/21/19.
//  Copyright © 2019 malith. All rights reserved.
//

import Foundation
import Firebase


class NibmStudents{
    
    var key: String
    var firstName: String
    var lastName: String
    var cityName: String
    var phoneNumber: String
    var FBprofileURL: String
    var profileURL: URL
    
    
    init(snap: DataSnapshot) {
        self.key = snap.key
        
        let nibmProfile = snap.value as! [String: Any]
        
        self.firstName = nibmProfile["firstName"] as! String
        self.lastName = nibmProfile["lastName"] as! String
        self.cityName = nibmProfile["cityName"] as! String
        self.FBprofileURL = nibmProfile["FBprofileURL"] as! String
        self.phoneNumber = nibmProfile["phoneNumber"] as! String
        self.profileURL = NSURL(string: (nibmProfile["FBprofileURL"] as? String ?? "no image")!)! as URL
        
        
    }
    
}
