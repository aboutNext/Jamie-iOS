//
//  User.swift
//  Jamie
//
//  Created by yunseo on 12/14/19.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit

struct Member: Codable, Equatable {
    var uid: String
    var email: String
    var displayName: String?
    var providerID: String?
    var createdDate: Date
}
