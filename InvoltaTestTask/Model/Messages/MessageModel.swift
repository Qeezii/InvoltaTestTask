//
//  MessageModel.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 19.06.2023.
//

import UIKit

struct MessageModel {
    let messageIdentifier: UUID
    let text: String
    let date: Date
    var avatarImage: UIImage?
}
