//
//  EventsViewController+TableView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import UIKit

// MARK: - UITableViewDataSource
extension EventsViewController: UITableViewDataSource {
    private func configureEventsCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(EventsTableViewCell.self, for: indexPath) else { return .init() }
        
        let data = model.data[indexPath.row]
        let prefferedItemWidth: CGFloat = {
            guard data.events.hasData == false, let bounds = view.window?.windowScene?.screen.bounds else { return 125 }
            
            return bounds.width
        }()
        
        cell.configure(image: data.category.icon, name: data.name)
        cell.configureCollectionView(
            delegate: self,
            tag: indexPath.row,
            prefferedWidth: prefferedItemWidth
        )
        
        return cell
    }
    
    private func configureNoDataCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(NoDataTableViewCell.self, for: indexPath) else { return .init() }
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        model.data.hasData ? configureEventsCell(for: indexPath) : configureNoDataCell(for: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
}
