//
//  MessageDetailViewController.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 19.06.2023.
//

import UIKit

protocol MessageDetailViewControllerDelegate: AnyObject {
    func deleteMessage(at index: Int, messageIdentifier: UUID)
}

final class MessageDetailViewController: UIViewController {

    // MARK: - Properties
    weak var delegate: MessageDetailViewControllerDelegate?
    private var indexMessage: Int = 0
    private var messageIdentifier: UUID = UUID()

    // MARK: - UI Elements
    private var messageTextLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Strings.DetailMessageScreen.textLabelDefaultText
        label.textAlignment = .center
        label.textColor = .label
        label.alpha = 0.0
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.0
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var messageDateLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Strings.DetailMessageScreen.dateLabelDefaultText
        label.alpha = 0.0
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppConstants.Strings.DetailMessageScreen.deleteButtonDefaultText,
                        for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.alpha = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 1.0) {
            self.messageTextLabel.alpha = 1.0
            self.messageDateLabel.alpha = 1.0
            self.avatarImageView.alpha = 1.0
            self.deleteButton.alpha = 1.0
        }
    }

    // MARK: - Methods
    private func configureUIElements() {
        configureMainView()
        configureMessageTextLabel()
        configureAvatarImageView()
        configureMessageDateLabel()
        configureDeleteButton()
    }
    private func configureMainView() {
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .systemBackground
    }
    private func configureMessageTextLabel() {
        view.addSubview(messageTextLabel)
        messageTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messageTextLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    private func configureAvatarImageView() {
        view.addSubview(avatarImageView)
        avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avatarImageView.bottomAnchor.constraint(
            equalTo: messageTextLabel.topAnchor,
            constant: AppConstants.Constraints.bottomSpacingMiddle).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    private func configureMessageDateLabel() {
        view.addSubview(messageDateLabel)
        messageDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messageDateLabel.topAnchor.constraint(
            equalTo: messageTextLabel.bottomAnchor,
            constant: AppConstants.Constraints.topSpacingSmall).isActive = true
    }
    private func configureDeleteButton() {
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        view.addSubview(deleteButton)
        deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        deleteButton.topAnchor.constraint(
            equalTo: messageDateLabel.bottomAnchor,
            constant: AppConstants.Constraints.topSpacingLarge).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setMessage(message: MessageModel, indexMessage: Int) {
        messageTextLabel.text = message.text
        messageDateLabel.text = AppConstants.Strings.DetailMessageScreen.dateLabelText(message.date)
        avatarImageView.image = message.avatarImage
        self.indexMessage = indexMessage
        self.messageIdentifier = message.messageIdentifier
    }
    @objc private func deleteButtonPressed() {
        delegate?.deleteMessage(at: indexMessage, messageIdentifier: messageIdentifier)
        navigationController?.popViewController(animated: true)
    }
}
