//
//  User.swift
//  Jamie
//
//  Created by yunseo on 12/14/19.
//  Copyright © 2019 yunseo. All rights reserved.
//

import UIKit

struct User: Codable, Equatable {
    var id: String?
    var email: String?
    var name: String
    var nickName: String?
    var image: String?
}

