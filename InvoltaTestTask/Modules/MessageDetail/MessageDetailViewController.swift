//
//  MessageDetailViewController.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 19.06.2023.
//

import UIKit

protocol MessageDetailViewControllerDelegate: AnyObject {
    func deleteMessage(at index: Int)
}

final class MessageDetailViewController: UIViewController {

    weak var delegate: MessageDetailViewControllerDelegate?
    private var indexMessage: Int = 0

    private var messageTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Текст сообщения"
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
        label.text = "Время отправки сообщения"
        label.alpha = 0.0
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить сообщение", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.alpha = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .systemBackground

        view.addSubview(messageTextLabel)
        messageTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messageTextLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        view.addSubview(avatarImageView)
        avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: messageTextLabel.topAnchor, constant: AppConstants.Constraints.bottomSpacingMiddle).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(messageDateLabel)
        messageDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messageDateLabel.topAnchor.constraint(equalTo: messageTextLabel.bottomAnchor).isActive = true

        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        view.addSubview(deleteButton)
        deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        deleteButton.topAnchor.constraint(equalTo: messageDateLabel.bottomAnchor, constant: AppConstants.Constraints.topSpacingLarge).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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

    func setMessage(message: MessageModel, indexMessage: Int) {
        messageTextLabel.text = message.text
        messageDateLabel.text = "Время отправки: \(message.date.formatted())"
        avatarImageView.image = message.image
        self.indexMessage = indexMessage
    }

    @objc private func deleteButtonPressed() {
        delegate?.deleteMessage(at: indexMessage)
        navigationController?.popViewController(animated: true)
    }
}
