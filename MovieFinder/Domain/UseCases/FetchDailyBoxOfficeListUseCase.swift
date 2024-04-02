//
//  FetchDailyBoxOfficeListUseCase.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import Foundation
import Combine

protocol FetchDailyBoxOfficeListUseCase {
    func fetchDailyBoxOfficeList() -> AnyPublisher<[DailyBoxOfficeList], Error>
}

final class DefaultFetchDailyBoxOfficeListUseCase {
    private let repository: DailyBoxOfficeListRepository
    
    init(repository: DailyBoxOfficeListRepository) {
        self.repository = repository
    }
}

// MARK: FetchDailyBoxOfficeListUseCase Confirmation
extension DefaultFetchDailyBoxOfficeListUseCase: FetchDailyBoxOfficeListUseCase {
    func fetchDailyBoxOfficeList() -> AnyPublisher<[DailyBoxOfficeList], Error> {
        return Future<[DailyBoxOfficeList], Error> { [weak self] promise in
            guard let self = self else { return }
            
            let yesterday = Date.now.addingTimeInterval(-86400)
            
            Task {
                do {
                    let result = try await self.repository.fetchDailyBoxOfficeList(date: yesterday)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
