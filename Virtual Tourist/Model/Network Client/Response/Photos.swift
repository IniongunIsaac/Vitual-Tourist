//
//  Photos.swift
//  Virtual Tourist
//
//  Created by Isaac Iniongun on 21/02/2020.
//  Copyright © 2020 Iniongun Group. All rights reserved.
//

import Foundation

struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [PhotoData]
}
