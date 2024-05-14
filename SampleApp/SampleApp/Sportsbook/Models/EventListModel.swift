//
//  EventListModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import Foundation

protocol EventListModelDelegate: AnyObject {
    func requestStatusUpdated(_ status: RequestStatus)
    func shouldUpdateRemainingTime()
}

class EventListModel<Service: FetchService> where Service.RequestData == [EventList] {
    private let urlPath: String
    private let service: Service
    private(set) var timer: Timer?
    var data: [EventList] = []
    weak var delegate: EventListModelDelegate?
    
    private var status: RequestStatus = .notStarted {
        didSet {
            guard status != oldValue else { return }
            delegate?.requestStatusUpdated(status)
        }
    }
    
    var numberOfCells: Int { status == .inProgress ? 0 : data.hasData ? data.count : 1 }
    
    init(service: Service, urlPath: String) {
        self.service = service
        self.urlPath = urlPath
    }
    // MARK: - Public
    func fetch() async {
        guard status != .inProgress else { return }
        status = .inProgress
        
        do {
            data = try await service.fetch(from: urlPath)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.status = .success
                self?.startTimer()
            }
        } catch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.status = .error
            }
        }
    }
    
    func fetchIfNeeded() {
        guard data.hasData == false else {
            startTimer()
            return
        }
        
        Task { await fetch() }
    }
    
    func startTimer() {
        guard timer == nil else { return }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: updateTime)
        RunLoop.current.add(timer, forMode: .common)
        timer.tolerance = 0.1
        
        self.timer = timer
    }
    
    func updateTime(_ timer: Timer) {
        delegate?.shouldUpdateRemainingTime()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func calculateRemainingTime(for event: Event) -> String? {
        guard event.startTime.asDate.isPastEvent == false else {
            return "Finished"
        }
        
        let timeLeft = Date.timeDifference(to: event.startTime.asDate)
        let components = [timeLeft.hour, timeLeft.minute, timeLeft.second].map { $0 ?? 0 }
        
        if components.first(where: { $0 < 0 }) != nil { return "Live now!" }
        return components.map { String($0) }.joined(separator: ":")
    }
}
