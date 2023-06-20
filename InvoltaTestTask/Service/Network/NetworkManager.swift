//
//  NetworkManager.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 15.06.2023.
//

import UIKit

final class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    /// Fetches data from a remote server based on the provided offset.
    /// - Parameters:
    ///   - offset: The offset value used for pagination.
    ///   - completion: A closure to be called with the result of the data fetch operation.
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

    /// Loads an avatar image.
    /// - Parameter completion: A closure to be called with the loaded image, or `nil` if the image loading failed.
    func loadImage(completion: @escaping (UIImage?) -> ()) {
        guard let url = API.getAvatarImage() else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                completion(image)
            }
        }
    }
}
