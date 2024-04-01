//
//  FetchDailyBoxOfficeListUseCase.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import Foundation

protocol FetchDailyBoxOfficeListUseCase {
    func fetchDailyBoxOfficeList() async throws -> [DailyBoxOfficeList]
}

final class DefaultFetchDailyBoxOfficeListUseCase {
    private let repository: DailyBoxOfficeListRepository
    
    init(repository: DailyBoxOfficeListRepository) {
        self.repository = repository
    }
}

// MARK: FetchDailyBoxOfficeListUseCase Confirmation
extension DefaultFetchDailyBoxOfficeListUseCase: FetchDailyBoxOfficeListUseCase {
    func fetchDailyBoxOfficeList() async throws -> [DailyBoxOfficeList] {
        try await repository.fetchDailyBoxOfficeList(date: .now)
    }
}
