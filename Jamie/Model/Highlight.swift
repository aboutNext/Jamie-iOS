//
//  Highlight.swift
//  About
//
//  Created by yunseo on 11/20/19.
//  Copyright © 2019 aboutNext. All rights reserved.
//

import Foundation

struct Highlight {
    var highlightID: String?
    var createdAt: Date?
    var goalDate: Date?
    var goal: String
    var uid: String
    var feedback: String?
    var isSuccess: Bool?

    
    var dictionary: [String: Any] {
        return [
//            "highlightID": highlightID,
//            "createdAt": createdAt,
//            "goalDate": goalDate,
            "goal": goal,
            "uid": uid
        ]
    }
}

extension Highlight {
    init?(dictionary: [String : Any]) {
//        guard let highlightID = dictionary["highlightID"] as? String,
//            let createdAt = dictionary["createdAt"] as? Date,
//            let goalDate = dictionary["goalDate"] as? Date,
           guard let goal = dictionary["goal"] as? String,
            let uid = dictionary["uid"] as? String else {
                return nil
        }
        self.init(goal: goal, uid: uid)

//        self.init(highlightID: highlightID, createdAt: createdAt, goalDate: goalDate, goal: goal, uid: uid)

    }
}
