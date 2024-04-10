//
//  FetchMovieDetailUseCase.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/3/24.
//

import Foundation
import Combine

protocol FetchMovieDetailUseCase {
    func fetchMovieDetail(movieCode code: String) -> AnyPublisher<DetailMovieInfo, Error>
}

final class DefaultFetchMovieDetailUseCase {
    private let repository: DailyBoxOfficeListRepository
    
    init(repository: DailyBoxOfficeListRepository) {
        self.repository = repository
    }
}

// MARK: FetchMovieDetailUseCase Confirmation
extension DefaultFetchMovieDetailUseCase: FetchMovieDetailUseCase {
    func fetchMovieDetail(movieCode code: String) -> AnyPublisher<DetailMovieInfo, Error> {
        return Future<DetailMovieInfo, Error> { [weak self] promise in
            guard let self = self else { return }
            
            Task {
                do {
                    let result = try await self.repository.fetchMovieDetail(movieCode: code)
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
