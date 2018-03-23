//
//  Comment.swift
//  IdeaApp
//
//  Created by Ban Er Win on 23/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import Foundation

class Comment {
    var uid : String = ""
    var comment : String = ""
    var userID : String = ""
    
    init() {
        
    }
    
    init(uid: String, dict: [String:Any]) {
        self.uid = uid
        self.comment = dict["Comment"] as? String ?? "No Comment"
        self.userID = dict ["UserID"] as? String ?? "No UserID"
    }
    
    
}
