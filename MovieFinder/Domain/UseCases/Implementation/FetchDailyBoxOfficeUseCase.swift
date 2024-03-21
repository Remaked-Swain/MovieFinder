import Foundation

final class FetchDailyBoxOfficeUseCase {
    private let repository: NetworkRepositoryProtocol
    
    init(repository: NetworkRepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: UseCase Confirmation
extension FetchDailyBoxOfficeUseCase {
    func execute() async {
        do {
            let request = DailyBoxOfficeRequestDTO(key: Bundle.main.koficAPIKey, date: .now)
            let entity = try await repository.fetch(request: request)
        } catch {
            print(error)
        }
    }
}
