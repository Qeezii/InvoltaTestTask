//
//  AppConstants.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 15.06.2023.
//

import Foundation

struct AppConstants {
    struct Strings {
        struct Network {
            static let scheme = "https"
            static let host = "numia.ru"

            struct Messages {
                static let path = "/api/getMessages"
                static let offsetQueryItem = "offset"
            }
        }
    }
}
