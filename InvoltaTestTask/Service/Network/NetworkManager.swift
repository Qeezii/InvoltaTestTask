//
//  NetworkManager.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 15.06.2023.
//

import Foundation

final class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    /// Fetches the data from the Github API
    /// - Parameters:
    ///   - offset: Message offset
    ///   - completion: The completion handler to be called when the data fetching is complete. The handler takes a `Result` object as its parameter, which contains either the successfully decoded data or an error.
    func fetchData<T: Decodable>(offset: Int,
                                 completion: @escaping (Result<T, Error>) -> ()) {

        guard let url = API.getMessages(offset: offset) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                if let error {
                    completion(.failure(error))
                }
                return
            }

            do {
                let decodeData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodeData))
            } catch (let error) {
                completion(.failure(error))
            }
        }.resume()
    }
}
