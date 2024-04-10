//
//  ContentView.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import SwiftUI
import Combine

final class DailyBoxOfficeListViewModel: ObservableObject {
    // MARK: Dependencies
    private let fetchDailyBoxOfficeListUseCase: FetchDailyBoxOfficeListUseCase
    private let fetchMovieDetailUseCase: FetchMovieDetailUseCase
    
    // MARK: Properties
    @Published var movies: [BasicMovieInfo]? = []
    @Published var selectedMovieInfo: MovieInfo?
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
            .cancel()
    }
}

struct DailyBoxOfficeListView: View {
    @ObservedObject private var vm: DailyBoxOfficeListViewModel
    
    private let navigationTitle: String = "일일 박스오피스 순위"
    
    init(vm: DailyBoxOfficeListViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        List(vm.movies ?? [], id: \.movieCode) { movie in
            movieCell(movie)
        }
        .navigationTitle(navigationTitle)
        .onAppear {
            vm.updateDailyBoxOfficeList()
        }
    }
}

extension DailyBoxOfficeListView {
    private func movieCell(_ movie: BasicMovieInfo) -> some View {
        NavigationLink {
            
        } label: {
            HStack {
                Text(movie.rank)
                    .font(.largeTitle)
                    .padding(4)
                
                VStack(alignment:.leading, spacing: 10) {
                    HStack {
                        Text(movie.movieName)
                            .font(.headline)
                            .lineLimit(1)
                    }
                    
                    HStack {
                        Text("누적 관객수: \(movie.audienceAccumulatedAmount)")
                    }
                }
            }
        }
    }
}
