//
//  EventsViewController+NoDataTableViewCellDelegate.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import Foundation

extension EventsViewController: NoDataTableViewCellDelegate {
    func didTapRetryButton(_ cell: NoDataTableViewCell) {
        model.fetchIfNeeded()
    }
}
