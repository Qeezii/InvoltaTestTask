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

            struct Messages {
                static let host = "numia.ru"
                static let path = "/api/getMessages"
                static let offsetQueryItem = "offset"
            }
            struct AvatarImage {
                static let host = "i.pravatar.cc"
                static let path = "/100"
            }
        }
        struct MessagesScreen {
            static let titleLabelText = "Тестовое задание"
            static let enterMessageTextFieldPlaceholder = "Сообщение"
            static let cellIdentifier = "MessagesTableViewCell"
            static let enterMessageButtonImage = "paperplane.fill"
        }
        struct DetailMessageScreen {
            static let textLabelDefaultText = "Текст сообщения"
            static let dateLabelDefaultText = "Время отправки сообщения"
            static let deleteButtonDefaultText = "Удалить сообщение"
            static func dateLabelText(_ date: Date) -> String {
                "Время отправки: \(date.formatted())"
            }
        }
        struct MessageCell {
            static let avatarDefaultImage = "person.circle"
        }
        struct CoreData {
            static let containerName = "MessagesCoreData"
        }
        struct Alert {
            static let alertErrorMessage = "Error"
            static let alertErrorButton = "Try again"
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
