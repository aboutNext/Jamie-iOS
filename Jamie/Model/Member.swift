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
//    var imageUrlString: String?
}

extension Decodable {
  /// Initialize from JSON Dictionary. Return nil on failure
  init?(dictionary value: [String:Any]){

    guard JSONSerialization.isValidJSONObject(value) else { return nil }
    guard let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) else { return nil }

    guard let newValue = try? JSONDecoder().decode(Self.self, from: jsonData) else { return nil }
    self = newValue
  }
}
