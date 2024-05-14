//
//  NoEventsCollectionViewCell.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import UIKit

class NoEventsCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    // MARK: - Private
    private func configure() {
        backgroundColor = .accent
        messageLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        messageLabel.textColor = .white
        messageLabel.text = "No Upcoming events!"
    }
}
