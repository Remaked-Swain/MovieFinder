//
//  MainViewModel.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/10/24.
//

import Combine

final class MainViewModel: ObservableObject {
    // MARK: Dependencies
    private let fetchDailyBoxOfficeListUseCase: FetchDailyBoxOfficeListUseCase
    private let fetchMovieDetailUseCase: FetchMovieDetailUseCase
    
    // MARK: Properties
    @Published var movies: [BasicMovieInfo]? = []
    @Published var selectedMovieInfo: DetailMovieInfo?
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        fetchDailyBoxOfficeListUseCase: FetchDailyBoxOfficeListUseCase,
        fetchMovieDetailUseCase: FetchMovieDetailUseCase
    ) {
        self.fetchDailyBoxOfficeListUseCase = fetchDailyBoxOfficeListUseCase
        self.fetchMovieDetailUseCase = fetchMovieDetailUseCase
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished: break
        case .failure(let error): print(error)
        }
    }
    
    func updateDailyBoxOfficeList() {
        fetchDailyBoxOfficeListUseCase.fetchDailyBoxOfficeList()
            .sink { [weak self] completion in
                self?.handleCompletion(completion)
            } receiveValue: { [weak self] value in
                self?.movies = value
            }
            .store(in: &cancellables)
    }
    
    func updateDetailMovieInfo(movieCode code: String) {
        fetchMovieDetailUseCase.fetchMovieDetail(movieCode: code)
            .sink { [weak self] completion in
                self?.handleCompletion(completion)
            } receiveValue: { [weak self] value in
                self?.selectedMovieInfo = value
            }
            .store(in: &cancellables)
    }
    
    func flushMovieInfo() {
        selectedMovieInfo = nil
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
}
