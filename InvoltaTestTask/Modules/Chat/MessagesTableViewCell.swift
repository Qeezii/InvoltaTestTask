//
//  MessagesTableViewCell.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 16.06.2023.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureMessageLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureMessageLabel() {
        addSubview(messageLabel)
        messageLabel.topAnchor.constraint(
            equalTo: topAnchor,
            constant: AppConstants.Constraints.topSpacingSmall).isActive = true
        messageLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: AppConstants.Constraints.leadingMiddle).isActive = true
        messageLabel.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: AppConstants.Constraints.trailingMiddle).isActive = true
        messageLabel.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: AppConstants.Constraints.bottomSpacingSmall).isActive = true
    }

    func setupMessageText(_ text: String) {
        messageLabel.text = text
    }
}
