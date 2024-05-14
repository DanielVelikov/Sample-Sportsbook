//
//  NoDataTableViewCell.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import UIKit

protocol NoDataTableViewCellDelegate: AnyObject {
    func didTapRetryButton(_ cell: NoDataTableViewCell)
}

class NoDataTableViewCell: UITableViewCell {
    private let noDataImageView = UIImageView(image: .init(.noData))
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    weak var delegate: NoDataTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: Self.identifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func configure() {
        isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        
        configureConstraints()
        configureMessageLabel()
        configureRetryButton()
    }
    
    private func configureConstraints() {
        [noDataImageView, messageLabel, retryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            noDataImageView.topAnchor.constraint(equalTo: topAnchor, constant: 125),
            noDataImageView.heightAnchor.constraint(equalToConstant: 75),
            noDataImageView.widthAnchor.constraint(equalToConstant: 75),
            noDataImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: noDataImageView.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func configureMessageLabel() {
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = .accent
        messageLabel.textAlignment = .center
        
        messageLabel.text = "No Data Found"
    }
    
    private func configureRetryButton() {
        retryButton.setTitle("Retry")
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .accent
        config.baseForegroundColor = .main
        config.titleAlignment = .center
        config.cornerStyle = .medium
        
        retryButton.configuration = config
        retryButton.isUserInteractionEnabled = true
    }
    
    @objc
    private func retryButtonTapped() {
        delegate?.didTapRetryButton(self)
    }
}
