//
//  DailyBoxOfficeListRepository.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import Foundation

protocol DailyBoxOfficeListRepository {
    func fetchDailyBoxOfficeList(date: Date) async throws -> [BasicMovieInfo]
    func fetchMovieDetail(movieCode code: String) async throws -> DetailMovieInfo
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
    
    private func mapToBasicMovieInfoList(with entity: DailyBoxOfficeModel) -> [BasicMovieInfo] {
        return entity.boxOfficeResult.dailyBoxOfficeList.map { $0.toDTO() }
    }
    
    private func mapToDetailMovieInfo(with entity: MovieDetailInfoModel) -> DetailMovieInfo {
        return entity.movieInfoResult.movieInfo.toDTO()
    }
    
    private func validateAPIKey() throws -> String {
        guard let key = apiKey else {
            throw DailyBoxOfficeListRepositoryError.invalidKey
        }
        return key
    }
}

// MARK: DailyBoxOfficeListRepository Confirmation
extension DefaultDailyBoxOfficeListRepository: DailyBoxOfficeListRepository {
    func fetchDailyBoxOfficeList(date: Date) async throws -> [BasicMovieInfo] {
        let key = try validateAPIKey()
        let endpoint = EndpointType.dailyBoxOffice(key: key, date: date)
        let entity = try await networkService.request(endpoint: endpoint, for: DailyBoxOfficeModel.self)
        return mapToBasicMovieInfoList(with: entity)
    }
    
    func fetchMovieDetail(movieCode code: String) async throws -> DetailMovieInfo {
        let key = try validateAPIKey()
        let endpoint = EndpointType.movieInfo(key: key, code: code)
        let entity = try await networkService.request(endpoint: endpoint, for: MovieDetailInfoModel.self)
        return mapToDetailMovieInfo(with: entity)
    }
}
