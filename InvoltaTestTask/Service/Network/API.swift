//
//  API.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 15.06.2023.
//

import Foundation

struct API {

    /// Returns the URL for retrieving messages with the specified offset.
    /// - Parameter offset: The offset value used for pagination.
    /// - Returns: The URL for retrieving messages, or `nil` if the URL components couldn't be constructed.
    static func getMessages(offset: Int) -> URL? {
        var components = URLComponents()
        components.scheme = AppConstants.Strings.Network.scheme
        components.host = AppConstants.Strings.Network.Messages.host
        components.path = AppConstants.Strings.Network.Messages.path
        components.queryItems = [
            URLQueryItem(name: AppConstants.Strings.Network.Messages.offsetQueryItem,
                         value: String(offset))
        ]
        return components.url
    }

    /// Returns the URL for retrieving the avatar image.
    /// - Returns: The URL for the avatar image, or `nil` if the URL components couldn't be constructed.
    static func getAvatarImage() -> URL? {
        var components = URLComponents()
        components.scheme = AppConstants.Strings.Network.scheme
        components.host = AppConstants.Strings.Network.AvatarImage.host
        components.path = AppConstants.Strings.Network.AvatarImage.path
        return components.url
    }
}
