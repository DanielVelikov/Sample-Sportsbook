//
//  FetchService.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.05.24.
//

import Foundation

protocol FetchService {
    associatedtype RequestData where RequestData: Decodable
    func fetch(from url: URL) async throws -> RequestData
    func fetch(from path: String) async throws -> RequestData
}

extension FetchService {
    func fetch(from url: URL) async throws -> RequestData {
        let (data, _) = try await URLSession.shared.data(for: .init(url: url))
        return try JSONDecoder().decode(RequestData.self, from: data)
    }
    
    func fetch(from path: String) async throws -> RequestData {
        guard let url = URL(string: path) else { throw RequestError.invalidURL }
        return try await fetch(from: url)
    }
}

class SportsbookService: FetchService {
    typealias RequestData = [EventList]
}
