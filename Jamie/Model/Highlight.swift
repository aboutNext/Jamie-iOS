//
//  Highlight.swift
//  About
//
//  Created by yunseo on 11/20/19.
//  Copyright © 2019 aboutNext. All rights reserved.
//

import Foundation

struct Highlight: Codable, Equatable {
    var uid: String?
    var createdDate: Date?
    var updatedDate: Date?
    var targetDate: Date?
    var highlight: String?
    var memo: String?
    var status: String?
}

/*
    var createdDate: 생성 날짜
    var updatedDate: 최근 마지막 업데이트 날짜
    var targetDate: 하이라이트 지정날짜(변경 불가)
 */
