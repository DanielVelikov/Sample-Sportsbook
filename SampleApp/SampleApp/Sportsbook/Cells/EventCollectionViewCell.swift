//
//  EventCollectionViewCell.swift
//  SampleApp
//
//  Created by Daniel Velikov on 12.05.24.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var countdownLabel: UILabel!
    @IBOutlet private var favouriteButton: UIButton!
    @IBOutlet private var firstParticipantLabel: UILabel!
    @IBOutlet private var secondParticipantLabel: UILabel!
    
    private var timeClosure: ReturnItemClosure<String?>?
    private var favouriteAction: VoidClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    // MARK: - Private
    private func configure() {
        favouriteButton.tintColor = .main
        [countdownLabel, firstParticipantLabel, secondParticipantLabel].forEach { $0?.textColor = .white }
    }
    
    // MARK: - Public
    func configure(
        firstParticipant: String,
        secondParticipant: String?,
        isFavourite: Bool,
        time: @escaping ReturnItemClosure<String?>,
        favouriteAction: @escaping VoidClosure
    ) {
        countdownLabel.text = time()
        self.timeClosure = time
        
        firstParticipantLabel.text = firstParticipant
        
        favouriteButton.setImage(.init(systemName: isFavourite ? "star.fill" : "star"))
        
        self.favouriteAction = favouriteAction
        
        guard let second = secondParticipant else {
            secondParticipantLabel.isHidden = true
            return
        }
        
        secondParticipantLabel.text = second
    }
    
    func updateTime() {
        countdownLabel.text = timeClosure?()
    }
    
    // MARK: - Actions
    @IBAction private func favouriteButtonTapped(_ sender: UIButton) {
        favouriteAction?()
    }
}
