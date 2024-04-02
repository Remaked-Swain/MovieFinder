//
//  DailyBoxOfficeListRepository.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import Foundation

protocol DailyBoxOfficeListRepository {
    func fetchDailyBoxOfficeList(date: Date) async throws -> [DailyBoxOfficeList]
}

enum DailyBoxOfficeListRepositoryError: Error, CustomDebugStringConvertible {
    case invalidKey
    case fetchFailed
    
    var debugDescription: String {
        switch self {
        case .invalidKey: "키가 유효하지 않음"
        case .fetchFailed: "값을 가져오는데 실패함"
        }
    }
}

final class DefaultDailyBoxOfficeListRepository {
    // MARK: Dependencies
    private let networkService: NetworkService
    
    // MARK: Properties
    private let apiKey: String? = Bundle.main.koficAPIKey
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func mapToDailyBoxOfficeList(with entity: DailyBoxOfficeModel) -> [DailyBoxOfficeList] {
        return entity.boxOfficeResult.dailyBoxOfficeList
    }
}

// MARK: DailyBoxOfficeListRepository Confirmation
extension DefaultDailyBoxOfficeListRepository: DailyBoxOfficeListRepository {
    func fetchDailyBoxOfficeList(date: Date) async throws -> [DailyBoxOfficeList] {
        guard let key = Bundle.main.koficAPIKey else {
            throw DailyBoxOfficeListRepositoryError.invalidKey
        }
        let endpoint = EndpointType.dailyBoxOffice(key: key, date: date)
        let entity = try await networkService.request(endpoint: endpoint, for: DailyBoxOfficeModel.self)
        return mapToDailyBoxOfficeList(with: entity)
    }
}
