//
//  Highlight.swift
//  About
//
//  Created by yunseo on 11/20/19.
//  Copyright © 2019 aboutNext. All rights reserved.
//

import Foundation

struct Highlight: Codable, Equatable {
    var highlightID: UUID
    var createdDate: Date
    var goalDate: Date
    var goal: String
    var feedback: String?
    var isSuccess: Bool?
    var uid: String

//    init(highlightID: UUID, date: Date, title: String) {
//        self.highlightID = highlightID
//        self.date = date
//        self.title = title
//    }
}
