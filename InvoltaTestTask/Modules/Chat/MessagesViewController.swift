//
//  MessagesViewController.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 15.06.2023.
//

import UIKit

final class MessagesViewController: UIViewController {

    // MARK: - Properties
    private var offset: Int = .zero
    private var messages: [MessageModel] = []
    private var isLoading: Bool = false
    private var messagesRemovedCount: Int = .zero
    private var messageAddedCount: Int = .zero
    private var enterMessageTextFieldBottomConstraint: NSLayoutConstraint?
    private var bottomInsetConstant: CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let constant = scene?.windows.first?.safeAreaInsets.bottom ?? .zero
        return constant == .zero ? AppConstants.Constraints.bottomSpacingSmall : -constant
    }

    // MARK: - UI Elements
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Strings.MessagesScreen.titleLabelText
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 18)
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
        tableView.contentInset.top = 10
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
        addUIElements()
        configureUIElements()
        registeringKeyboardEventNotifications()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Methods
    private func addUIElements() {
        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        view.addSubview(enterMessageView)
        enterMessageView.addSubview(enterMessageTextField)
        enterMessageView.addSubview(enterMessageButton)
        view.addSubview(messagesTableView)
        view.addSubview(spinnerActivityIndicatorView)
    }
    private func configureUIElements() {
        configureMainView()
        configureTitleView()
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
    private func configureTitleView() {
        titleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    private func configureTitleLabel() {
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    private func configureEnterMessageView() {
        enterMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        enterMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        enterMessageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    private func configureEnterMessageButton() {
        enterMessageButton.addTarget(self, action: #selector(sendMessageButtonPressed), for: .touchUpInside)

        enterMessageButton.trailingAnchor.constraint(
            equalTo: enterMessageView.trailingAnchor,
            constant: AppConstants.Constraints.trailingSmall).isActive = true
        enterMessageButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        enterMessageButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        enterMessageButton.bottomAnchor.constraint(equalTo: enterMessageTextField.bottomAnchor).isActive = true
    }
    private func configureEnterMessageTextField() {
        enterMessageTextField.delegate = self

        enterMessageTextField.topAnchor.constraint(
            equalTo: enterMessageView.topAnchor,
            constant: AppConstants.Constraints.topSpacingSmall).isActive = true
        enterMessageTextField.leadingAnchor.constraint(
            equalTo: enterMessageView.leadingAnchor,
            constant: AppConstants.Constraints.leadingMiddle).isActive = true
        enterMessageTextField.trailingAnchor.constraint(
            equalTo: enterMessageButton.leadingAnchor,
            constant: AppConstants.Constraints.trailingSmall).isActive = true
        enterMessageTextFieldBottomConstraint = enterMessageTextField.bottomAnchor.constraint(
            equalTo: enterMessageView.bottomAnchor,
            constant: bottomInsetConstant)
        enterMessageTextFieldBottomConstraint?.isActive = true
        enterMessageTextField.heightAnchor.constraint(equalToConstant: 27).isActive = true
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
        activityIndicator.transform = CGAffineTransform(scaleX: 1, y: -1)

        messagesTableView.tableFooterView = activityIndicator
        messagesTableView.tableFooterView?.isHidden = true
        messagesTableView.addGestureRecognizer(swipeDownRecognizer)

        messagesTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messagesTableView.bottomAnchor.constraint(equalTo: enterMessageView.topAnchor).isActive = true
    }
    private func configureSpinnerActivityIndicatorView() {
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
        guard !isLoading else { return }
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
                loadSuccess(messagesResponse: messageResponse.result)
            case .failure(let failure):
                isLoading.toggle()
                showSpinner(false)
                showErrorAlert(message: failure.localizedDescription)
            }
        }
    }
    private func loadSuccess(messagesResponse: [String]) {
        if messages.isEmpty {
            messages += CoreDataManager.shared.loadMessages()
            messageAddedCount += messages.count
        }
        let auxOffset = offset - messagesRemovedCount + messageAddedCount

        messagesResponse.forEach( { messages.append(.init(messageIdentifier: UUID(),
                                                          text: $0,
                                                          date: Date())) } )

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            let group = DispatchGroup()

            self.messages[auxOffset..<self.messages.count]
                .enumerated()
                .forEach { index, message in
                    group.enter()
                    NetworkManager.shared.loadImage { [weak self] image in
                        guard let self = self else { return }
                        self.messages[index + auxOffset].avatarImage = image
                        group.leave()
                    }
                }

            group.notify(queue: .main) { [weak self] in
                guard let self else { return }
                UIView.transition(with: self.view,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve) {
                    self.spinnerActivityIndicatorView.stopAnimating()
                    self.showSpinner(false)
                    self.messagesTableView.reloadData()
                }
            }
        }
        offset += messagesResponse.count
        isLoading.toggle()
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
    private func showErrorAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(title: AppConstants.Strings.Alert.alertErrorMessage,
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AppConstants.Strings.Alert.alertErrorButton,
                                          style: .default,
                                          handler: { [weak self] _ in
                self?.getMessage()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc private func sendMessageButtonPressed() {
        guard let text = enterMessageTextField.text,
              !text.isEmpty else { return }

        NetworkManager.shared.loadImage { image in
            let message = MessageModel(messageIdentifier: UUID(),
                                       text: text,
                                       date: Date(),
                                       avatarImage: image)
            self.messages.insert(message, at: 0)
            CoreDataManager.shared.addMessage(message)
            self.messageAddedCount += 1
            DispatchQueue.main.async {
                UIView.transition(with: self.view,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve) {
                    self.enterMessageTextField.text = ""
                    self.messagesTableView.insertRows(at: [IndexPath(row: 0, section: 0)],
                                                      with: .automatic)
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
        enterMessageTextFieldBottomConstraint?.constant = -keyboardHeight + AppConstants.Constraints.bottomSpacingSmall
        updateConstraints()
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        enterMessageTextFieldBottomConstraint?.constant = bottomInsetConstant
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
        let message = messages[indexPath.row]
        (cell as? MessagesTableViewCell)?.setupCell(text: message.text, image: message.avatarImage)
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
        hideKeyboard()
        navigationController?.pushViewController(messageDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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
    func deleteMessage(at index: Int, messageIdentifier: UUID) {
        messages.remove(at: index)
        CoreDataManager.shared.removeMessage(messageIdentifier)
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
