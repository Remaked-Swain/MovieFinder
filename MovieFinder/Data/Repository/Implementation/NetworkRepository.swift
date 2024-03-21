import Foundation

struct NetworkRepository {
    private let networkService: NetworkServiceProtocol
    private let decoder: JSONDecoder
    
    init(networkService: NetworkServiceProtocol = NetworkService(), decoder: JSONDecoder = JSONDecoder()) {
        self.networkService = networkService
        self.decoder = decoder
    }
}

// MARK: Private Methods
extension NetworkRepository {
    private func decode<T: Decodable>(for type: T.Type, data: Data) throws -> T {
        guard let entity = try? decoder.decode(T.self, from: data) else {
            throw RepositoryError.decodingFailed
        }
        return entity
    }
}

// MARK: NetworkRepositoryProtocol Confirmation
extension NetworkRepository: NetworkRepositoryProtocol {
    func fetch(request: DailyBoxOfficeRequestDTO) async throws -> DailyBoxOfficeModel {
        let data = try await networkService.fetchData(to: .dailyBoxOffice(key: request.key, date: request.date), delegate: nil)
        let entity = try decode(for: DailyBoxOfficeModel.self, data: data)
        return entity
    }
    
    func fetch(request: MovieInfoRequestDTO) async throws -> MovieInfoModel {
        let data = try await networkService.fetchData(to: .movieInfo(key: request.key, code: request.code), delegate: nil)
        let entity = try decode(for: MovieInfoModel.self, data: data)
        return entity
    }
}
