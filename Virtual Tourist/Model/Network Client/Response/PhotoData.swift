//
//  PhotoData.swift
//  Virtual Tourist
//
//  Created by Isaac Iniongun on 21/02/2020.
//  Copyright © 2020 Iniongun Group. All rights reserved.
//

import Foundation

struct PhotoData: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    let url: String
    let height, width: Int

    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        case url = "url_m"
        case height = "height_m"
        case width = "width_m"
    }
}
