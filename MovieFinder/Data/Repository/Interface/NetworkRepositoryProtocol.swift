import Foundation

protocol NetworkRepositoryProtocol {
    func fetch(request: DailyBoxOfficeRequestDTO) async throws -> DailyBoxOfficeModel
    func fetch(request: MovieInfoRequestDTO) async throws -> MovieInfoModel
}
