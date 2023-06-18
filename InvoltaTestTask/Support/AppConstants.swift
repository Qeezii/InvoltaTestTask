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

        struct MessagesScreen {
            static let titleLabelText = "Тестовое задание"
            static let enterMessageTextFieldPlaceholder = "Сообщение"
            static let cellIdentifier = "MessagesTableViewCell"
            static let enterMessageButtonImage = "paperplane.fill"
        }
    }

    struct Constraints {
        static let topSpacingLarge: CGFloat = 24
        static let topSpacingMiddle: CGFloat = 16
        static let topSpacingSmall: CGFloat = 8

        static let leadingLarge: CGFloat = 24
        static let leadingMiddle: CGFloat = 16
        static let leadingSmall: CGFloat = 8

        static let trailingLarge: CGFloat = -24
        static let trailingMiddle: CGFloat = -16
        static let trailingSmall: CGFloat = -8

        static let bottomSpacingLarge: CGFloat = -24
        static let bottomSpacingMiddle: CGFloat = -16
        static let bottomSpacingSmall: CGFloat = -8
    }
}
