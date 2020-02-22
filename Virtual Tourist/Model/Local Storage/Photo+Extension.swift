//
//  Photo+Extension.swift
//  Virtual Tourist
//
//  Created by Isaac Iniongun on 22/02/2020.
//  Copyright © 2020 Iniongun Group. All rights reserved.
//

import Foundation

extension Photo {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
