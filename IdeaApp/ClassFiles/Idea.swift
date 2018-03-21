//
//  Idea.swift
//  IdeaApp
//
//  Created by Ban Er Win on 21/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import Foundation

class Idea {
    var uid : String = ""
    var title : String = ""
    var status : String = ""
    var date : String = ""
    
    init() {
        
    }
    
    init(uid: String, dict: [String:Any]) {
        self.uid = uid
        self.title = dict["IdeaTitle"] as? String ?? "No Idea"
        self.status = dict["IdeaStatus"] as? String ?? "No Status"
        self.date = dict["IdeaDate"] as? String ?? "No Date"
        
    }
    
}
