//
//  EventsTableViewCell.swift
//  SampleApp
//
//  Created by Daniel Velikov on 12.05.24.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    struct Constants {
        static let collapseImage = UIImage(systemName: "chevron.up")
        static let expandImage = UIImage(systemName: "chevron.down")
    }
    
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var expandToggleButton: UIButton!
    @IBOutlet private(set) var collectionView: UICollectionView!
    @IBOutlet private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var isExpanded = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .main
        configureCollectionView()
        expandToggleButton.setTitle("")
        expandToggleButton.setBackgroundImage(Constants.collapseImage)
    }
    
    // MARK: - Private
    private func configureCollectionView() {
        collectionView.registerCellNib(EventCollectionViewCell.self)
        collectionView.registerCellNib(NoEventsCollectionViewCell.self)
        collectionView.backgroundColor = .accent
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Public
    func configure(image: UIImage, name: String) {
        iconImageView.image = image
        nameLabel.text = name
    }
    
    func configureCollectionView(delegate: CollectionViewDelegate, tag: Int, prefferedWidth: CGFloat) {
        collectionView.dataSource = delegate
        collectionView.delegate = delegate
        collectionView.tag = tag
        
        collectionView.flowLayout?.itemSize = .init(width: prefferedWidth, height: 100)
        collectionView.reloadData()
    }
    
    func updateTime() {
        let cells = collectionView.indexPathsForVisibleItems.compactMap { collectionView.cellForItem(at: $0) as? EventCollectionViewCell }
        cells.forEach { $0.updateTime() }
    }
    
    // MARK: - Actions
    @IBAction private func expandToggleTapped(_ sender: UIButton) {
        isExpanded.toggle()
        
        UIView.animate(withDuration: 1.5) { [weak self] in
            guard let self = self else { return }
            expandToggleButton.setImage(isExpanded ? Constants.collapseImage : Constants.expandImage)
            collectionViewHeightConstraint.constant = isExpanded ? 110 : 0
            invalidateIntrinsicContentSize()
        }
    }
}
