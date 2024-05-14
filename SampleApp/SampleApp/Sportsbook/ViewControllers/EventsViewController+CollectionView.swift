//
//  EventsViewController+CollectionView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension EventsViewController: UICollectionViewDataSource {
    // MARK: - Private
    private func configureCollectionViewEventsCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(EventCollectionViewCell.self, for: indexPath) else { return .init() }
        
        let event = model.data[collectionView.tag].events[indexPath.row]
        
        cell.configure(
            firstParticipant: event.participants.first,
            secondParticipant: event.participants.second,
            isFavourite: event.isFavourite,
            time: { [weak self] in
                self?.model.calculateRemainingTime(for: event)
            }
        ) { [weak self] in
            self?.model.data[collectionView.tag].events[indexPath.row].isFavourite.toggle()
            collectionView.reloadData()
        }
        
        return cell
    }
    
    private func configureCollectionViewNoEventsCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueCell(NoEventsCollectionViewCell.self, for: indexPath) ?? .init()
    }
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let events = model.data[collectionView.tag].events
        
        return events.hasData ? events.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        model.data[collectionView.tag].events.hasData ? configureCollectionViewEventsCell(collectionView, for: indexPath) : configureCollectionViewNoEventsCell(collectionView, for: indexPath)
    }
}

// MARK: - UICollectionViewDelegate
extension EventsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        false
    }
}
