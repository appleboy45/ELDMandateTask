//
//  VideoFilesData.swift
//  ELDMandateTask
//
//  Created by Vineet Singh on 10/07/20.
//  Copyright © 2020 ELDMandate. All rights reserved.
//

import Foundation

struct VideoFilesData: Codable {
    var dateTime, fileSize, status, thumbnail: String?
    var id: Int?
}

