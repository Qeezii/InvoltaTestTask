//
//  API.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 15.06.2023.
//

import Foundation

struct API {

    /// Returns the URL for getting the messages from the server.
    static func getMessages(offset: Int) -> URL? {
        var components = URLComponents()
        components.scheme = AppConstants.Strings.Network.scheme
        components.host = AppConstants.Strings.Network.host
        components.path = AppConstants.Strings.Network.Messages.path
        components.queryItems = [
            URLQueryItem(name: AppConstants.Strings.Network.Messages.offsetQueryItem,
                         value: String(offset))
        ]
        return components.url
    }
}
