//
//  Highlight.swift
//  About
//
//  Created by yunseo on 11/20/19.
//  Copyright © 2019 aboutNext. All rights reserved.
//

import Foundation

struct Highlight : Codable {
    var highlightID: String
    var uid: String
    var createdAt: Date?
    var goalDate: Date?
    var goal: String?
    var feedback: String?
    var isSuccess: Bool?
    
}

