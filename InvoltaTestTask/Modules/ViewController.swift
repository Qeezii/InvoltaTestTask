//
//  ViewController.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 15.06.2023.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    private var offset: Int = 0
    private var messages: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getMessage()
    }

    private func getMessage() {
        NetworkManager.shared.fetchData(offset: offset) { [weak self] (result: Result<MessageResponse, Error>) in
            guard let self else { return }
            switch result {
            case .success(let messageResponse):
                DispatchQueue.main.async {
                    self.messages += messageResponse.result
                    self.offset += messageResponse.result.count
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

