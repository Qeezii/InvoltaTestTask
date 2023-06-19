//
//  MessagesViewController.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 15.06.2023.
//

import UIKit

final class MessagesViewController: UIViewController {

    // MARK: - Properties
    private var offset: Int = 0
    private var messages: [MessageModel] = []
    private var isLoading: Bool = false
    private var failedLoadCounter: Int = 0
    private var messagesRemovedCount: Int = 0
    private var enterMessageViewBottomConstraint: NSLayoutConstraint?

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Strings.MessagesScreen.titleLabelText
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
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
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    private let enterMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let enterMessageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AppConstants.Strings.MessagesScreen.enterMessageTextFieldPlaceholder
        textField.backgroundColor = .systemBackground
        textField.textColor = .label
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        let leftView = UIView(frame: CGRect(x: 10, y: 0, width: 7, height: textField.bounds.height))
        leftView.backgroundColor = .clear
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.contentVerticalAlignment = .center
        textField.returnKeyType = .send
        return textField
    }()
    private let enterMessageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: AppConstants.Strings.MessagesScreen.enterMessageButtonImage),
                        for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - UIRecognizers
    private lazy var swipeDownRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.addTarget(self, action: #selector(hideKeyboard))
        recognizer.delegate = self
        recognizer.direction = UISwipeGestureRecognizer.Direction.up
        return recognizer
    }()

    // MARK: - Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessage()
        configureUIElements()
        registeringKeyboardEventNotifications()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Methods
    private func configureUIElements() {
        configureMainView()
        configureTitleLabel()
        configureEnterMessageView()
        configureEnterMessageButton()
        configureEnterMessageTextField()
        configureMessagesTableView()
        configureSpinnerActivityIndicatorView()
    }
    private func configureMainView() {
        view.backgroundColor = .systemBackground
    }
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    private func configureEnterMessageView() {
        view.addSubview(enterMessageView)
        enterMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        enterMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        enterMessageViewBottomConstraint = enterMessageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        enterMessageViewBottomConstraint?.isActive = true
        enterMessageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    private func configureEnterMessageButton() {
        enterMessageButton.addTarget(self, action: #selector(sendMessageButtonPressed), for: .touchUpInside)
        enterMessageView.addSubview(enterMessageButton)
        enterMessageButton.topAnchor.constraint(equalTo: enterMessageView.topAnchor).isActive = true
        enterMessageButton.trailingAnchor.constraint(equalTo: enterMessageView.trailingAnchor,
                                                     constant: AppConstants.Constraints.trailingSmall).isActive = true
        enterMessageButton.bottomAnchor.constraint(equalTo: enterMessageView.bottomAnchor).isActive = true
        enterMessageButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    private func configureEnterMessageTextField() {
        enterMessageTextField.delegate = self
        enterMessageView.addSubview(enterMessageTextField)
        enterMessageTextField.topAnchor.constraint(equalTo: enterMessageView.topAnchor, constant: AppConstants.Constraints.topSpacingSmall).isActive = true
        enterMessageTextField.leadingAnchor.constraint(equalTo: enterMessageView.leadingAnchor,
                                                       constant: AppConstants.Constraints.leadingSmall).isActive = true
        enterMessageTextField.trailingAnchor.constraint(equalTo: enterMessageButton.leadingAnchor,
                                                        constant: AppConstants.Constraints.trailingSmall).isActive = true
        enterMessageTextField.bottomAnchor.constraint(equalTo: enterMessageView.bottomAnchor, constant: AppConstants.Constraints.bottomSpacingSmall).isActive = true
    }
    private func configureMessagesTableView() {
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.register(MessagesTableViewCell.self,
                                   forCellReuseIdentifier: AppConstants.Strings.MessagesScreen.cellIdentifier)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: messagesTableView.bounds.width, height: 44)
        messagesTableView.tableFooterView = activityIndicator
        messagesTableView.tableFooterView?.isHidden = true
        messagesTableView.addGestureRecognizer(swipeDownRecognizer)

        view.addSubview(messagesTableView)
        messagesTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messagesTableView.bottomAnchor.constraint(equalTo: enterMessageView.topAnchor).isActive = true
    }
    private func configureSpinnerActivityIndicatorView() {
        view.addSubview(spinnerActivityIndicatorView)
        spinnerActivityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinnerActivityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    private func registeringKeyboardEventNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
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
                guard !messageResponse.result.isEmpty else {
                    showSpinner(false)
                    return
                }
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
        let auxOffset = offset - messagesRemovedCount
        var counter = offset
        messages.forEach( { self.messages.append(.init(text: $0, date: Date())) } )
        DispatchQueue.global(qos: .userInteractive).async {
            for index in auxOffset..<self.messages.count {
                NetworkManager.shared.loadImage { image in
                    self.messages[index].image = image
                    counter += 1
                    if counter == self.messages.count {
                        DispatchQueue.main.async {
                            UIView.transition(with: self.view,
                                              duration: 0.2,
                                              options: .transitionCrossDissolve) {
                                self.spinnerActivityIndicatorView.stopAnimating()
                                self.showSpinner(false)
                                self.messagesTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        offset += messages.count
        isLoading.toggle()
        failedLoadCounter = 0
    }
    private func showSpinner(_ mode: Bool) {
        DispatchQueue.main.async {
            self.messagesTableView.tableFooterView?.isHidden = mode ? false : true
        }
    }
    private func updateConstraints() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    @objc private func sendMessageButtonPressed() {
        guard let text = enterMessageTextField.text,
              !text.isEmpty else { return }
        NetworkManager.shared.loadImage { image in
            self.messages.insert(.init(text: text, date: Date(), image: image), at: 0)
            DispatchQueue.main.async {
                UIView.transition(with: self.view,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve) {
                    self.enterMessageTextField.text = ""
                    self.messagesTableView.reloadData()
                }
            }
        }
    }
    @objc private func hideKeyboard() {
        enterMessageTextField.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.size.height
        enterMessageViewBottomConstraint?.constant = -keyboardHeight
        updateConstraints()
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        enterMessageViewBottomConstraint?.constant = 0
        updateConstraints()
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
        (cell as? MessagesTableViewCell)?.setupMessageText(messages[indexPath.row].text)
        (cell as? MessagesTableViewCell)?.setupAvatarImage(messages[indexPath.row].image)
        return cell
    }
}
// MARK: - UITableViewDelegate
extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let messageDetailVC = MessageDetailViewController()
        messageDetailVC.delegate = self
        messageDetailVC.setMessage(message: message, indexMessage: indexPath.row)
        navigationController?.pushViewController(messageDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == messages.count - 1 else { return }
        getMessage()
    }
}
// MARK: - UITextFieldDelegate
extension MessagesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessageButtonPressed()
        hideKeyboard()
        return true
    }
}
// MARK: - UIGestureRecognizerDelegate
extension MessagesViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
// MARK: - MessageDetailViewControllerDelegate
extension MessagesViewController: MessageDetailViewControllerDelegate {
    func deleteMessage(at index: Int) {
        messages.remove(at: index)
        messagesRemovedCount += 1
        DispatchQueue.main.async {
            UIView.transition(with: self.view,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.messagesTableView.reloadData()
            }
        }
    }
}
