//
//  EventsViewController+EventListModelDelegate.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import UIKit

// MARK: - EventModelDelegate
extension EventsViewController: EventListModelDelegate {
    func requestStatusUpdated(_ status: RequestStatus) {
        switch status {
        case .notStarted:
            break
        case .inProgress, .success, .error:
            onMain { [weak self] in
                self?.toggleLoadingIndicator()
                self?.tableView.reloadData()
            }
        }
    }
    
    func shouldUpdateRemainingTime() {
        tableView.indexPathsForVisibleRows?.forEach { (tableIndex) in
            guard model.data[tableIndex.row].events.hasData else { return }
            
            let eventsCell = tableView.cellForRow(at: tableIndex) as? EventsTableViewCell
            let eventIndexes = eventsCell?.collectionView.indexPathsForVisibleItems ?? []
            
            var expiredEvents = eventIndexes.filter { (index) in
                model.data[tableIndex.row].events[index.item].startTime.asDate.isPastEvent
            }
            
            guard expiredEvents.isEmpty == false else {
                eventsCell?.updateTime()
                return
            }
            expiredEvents.sort(by: { $0.item < $1.item })
            
            expiredEvents.reversed().forEach { model.data[tableIndex.row].events.remove(at: $0.item) }
            eventsCell?.collectionView.deleteItems(at: expiredEvents)
        }
    }
}
