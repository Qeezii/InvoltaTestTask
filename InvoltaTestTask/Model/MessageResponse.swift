//
//  MessageResponse.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 15.06.2023.
//

import UIKit

struct MessageResponse: Codable {
    let result: [String]
}

struct MessageModel {
    var text: String
    var date: Date
    var image: UIImage?
}
