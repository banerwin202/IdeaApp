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
    
    var ideaPicUID : String = ""
    var userID : String = ""
    var timeStamp : Int = 0
    var ideaPicURL : String = ""
    
    init() {
        
    }
    
    init(uid: String, dict: [String:Any]) {
        self.uid = uid
        self.title = dict["IdeaTitle"] as? String ?? "No Idea"
        self.status = dict["IdeaStatus"] as? String ?? "No Status"
        self.date = dict["IdeaDate"] as? String ?? "No Date"
        
        self.ideaPicUID = uid
        self.userID = dict["userID"] as? String ?? "No ID"
        self.timeStamp = dict["timeStamp"] as? Int ?? 0
        self.ideaPicURL = dict["ideaPicURL"] as? String ?? "No URL"

        

        
    }
    
}
