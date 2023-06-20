//
//  MessagesTableViewCell.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 16.06.2023.
//

import UIKit

final class MessagesTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Override funcs
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addUIElements()
        configureUIElements()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Methods
    private func addUIElements() {
        addSubview(messageLabel)
        addSubview(avatarImageView)
    }
    private func configureUIElements() {
        configureAvatarImageView()
        configureMessageLabel()
    }
    private func configureMessageLabel() {
        messageLabel.topAnchor.constraint(
            equalTo: topAnchor,
            constant: AppConstants.Constraints.topSpacingSmall).isActive = true
        messageLabel.leadingAnchor.constraint(
            equalTo: avatarImageView.trailingAnchor,
            constant: AppConstants.Constraints.leadingSmall).isActive = true
        messageLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: AppConstants.Constraints.trailingMiddle).isActive = true
        messageLabel.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: AppConstants.Constraints.bottomSpacingSmall).isActive = true
    }
    private func configureAvatarImageView() {
        avatarImageView.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: AppConstants.Constraints.leadingMiddle).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    func setupCell(text: String, image: UIImage?) {
        messageLabel.text = text
        switch image {
        case .none:
            avatarImageView.image = UIImage(systemName: AppConstants.Strings.MessageCell.avatarDefaultImage)
        case .some(let imageUnwrap):
            avatarImageView.image = imageUnwrap
        }
    }
}
