//
//  EventsViewController.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.05.24.
//

import UIKit

class EventsViewController: UIViewController {
    @IBOutlet private(set) var tableView: UITableView!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    
    private(set) var model: EventListModel<SportsbookService>
    
    init(model: EventListModel<SportsbookService>) {
        self.model = model
        super.init(nibName: Self.identifier, bundle: .main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        loadingIndicator.isHidden = true
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.fetchIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.stopTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerCellNib(EventsTableViewCell.self)
        tableView.registerCell(NoDataTableViewCell.self)
    }
    
    // MARK: - Public
    func toggleLoadingIndicator() {
        guard loadingIndicator.isHidden == true else {
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
            return
        }
        
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
    }
}
