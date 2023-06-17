//
//  MessagesViewController.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 15.06.2023.
//

import UIKit

class MessagesViewController: UIViewController {

    // MARK: - Properties
    private var offset: Int = 0
    private var messages: [String] = []
    private var isLoading: Bool = false
    private var failedLoadCounter: Int = 0

    // MARK: - UI Elements
    private let messagesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return tableView
    }()
    private let spinnerActivityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    // MARK: - Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getMessage()
        configureMessagesTableView()
    }

    // MARK: - Methods
    private func configureMessagesTableView() {
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.register(MessagesTableViewCell.self,
                                   forCellReuseIdentifier: AppConstants.Strings.MessagesScreen.cellIdentifier)
        messagesTableView.tableFooterView = spinnerActivityIndicatorView
        messagesTableView.tableFooterView?.isHidden = true
        spinnerActivityIndicatorView.frame = CGRect(x: 0, y: 0, width: messagesTableView.bounds.width, height: 44)

        view.addSubview(messagesTableView)
        messagesTableView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: AppConstants.Constraints.topSpacingMiddle).isActive = true
        messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messagesTableView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: AppConstants.Constraints.bottomSpacingMiddle).isActive = true
    }
    private func getMessage() {
        guard !isLoading,
              failedLoadCounter < 3 else { return }
        if !messages.isEmpty {
            showSpinner(true)
        }
        isLoading.toggle()
        NetworkManager.shared.fetchData(offset: offset) { [weak self] (result: Result<MessageResponse, Error>) in
            guard let self else { return }
            switch result {
            case .success(let messageResponse):
                showSpinner(false)
                guard !messageResponse.result.isEmpty else { return }
                loadSuccess(messages: messageResponse.result)
            case .failure(let failure):
                print(failure.localizedDescription)
                failedLoadCounter += 1
                isLoading.toggle()
                showSpinner(false)
                guard failedLoadCounter < 3 else { return }
                getMessage()
            }
        }
    }
    private func loadSuccess(messages: [String]) {
        DispatchQueue.main.async {
            self.messages += messages
            self.offset += messages.count
            self.isLoading.toggle()
            self.failedLoadCounter = 0
            self.messagesTableView.reloadData()
        }
    }
    private func showSpinner(_ mode: Bool) {
        DispatchQueue.main.async {
            self.messagesTableView.tableFooterView?.isHidden = mode ? false : true
        }
    }
}

// MARK: - Extensions
// MARK: - UITableViewDataSource
extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Strings.MessagesScreen.cellIdentifier,
                                                 for: indexPath)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        (cell as? MessagesTableViewCell)?.setupMessageText(messages[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == messages.count - 1 else { return }
        getMessage()
    }
}
