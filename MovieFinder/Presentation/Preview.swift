import Foundation

struct Preview {
    static var instance = Preview()
    
    lazy var sessionManager = DefaultNetworkSessionManager()
    lazy var networkService = DefaultNetworkService(sessionManager: sessionManager)
    lazy var repository = DefaultDailyBoxOfficeListRepository(networkService: networkService)
    lazy var fetchDailyBoxOfficeListUseCase = DefaultFetchDailyBoxOfficeListUseCase(repository: repository)
    lazy var fetchMovieDetailUseCase = DefaultFetchMovieDetailUseCase(repository: repository)
    lazy var vm = DailyBoxOfficeListViewModel(fetchDailyBoxOfficeListUseCase: fetchDailyBoxOfficeListUseCase)
}
