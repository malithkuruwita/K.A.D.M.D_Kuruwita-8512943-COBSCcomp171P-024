//
//  Homework.swift
//  NIBMConnect
//
//  Created by malith on 5/22/19.
//  Copyright © 2019 malith. All rights reserved.
//

import Foundation

class Homework: NSObject, NSCoding{
    
    var title: String?
    var details: String?
    var date: Date?
    
    init(title: String, details: String, date: Date) {
        self.title = title
        self.details = details
        self.date = date
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "name") as? String;
        self.details = aDecoder.decodeObject(forKey: "age") as? String;
        self.date = aDecoder.decodeObject(forKey: "html") as? Date;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "name");
        aCoder.encode(self.details, forKey: "age");
        aCoder.encode(self.date, forKey: "html");
    }
    
    
}
