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
    
    // MARK: Properties
    @Published var movies: [BasicMovieInfo]? = []
    private var dailyBoxOfficeListSubscription: AnyCancellable?
    
    init(fetchDailyBoxOfficeListUseCase: FetchDailyBoxOfficeListUseCase) {
        self.fetchDailyBoxOfficeListUseCase = fetchDailyBoxOfficeListUseCase
    }
    
    func updateDailyBoxOfficeList() {
        dailyBoxOfficeListSubscription = fetchDailyBoxOfficeListUseCase.fetchDailyBoxOfficeList()
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error): print(error)
                }
            } receiveValue: { [weak self] value in
                self?.movies = value
            }
    }
}

struct DailyBoxOfficeListView: View {
    @ObservedObject private var vm: DailyBoxOfficeListViewModel
    
    private let navigationTitle: String = "일일 박스오피스 순위"
    
    init(vm: DailyBoxOfficeListViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        NavigationStack {
            List(vm.movies ?? [], id: \.movieCode) { movie in
                movieCell(movie)
            }
            .navigationTitle(navigationTitle)
            .onAppear {
                vm.updateDailyBoxOfficeList()
            }
        }
    }
}

#Preview {
    DailyBoxOfficeListView(vm: Preview.instance.vm)
}

extension DailyBoxOfficeListView {
    private func movieCell(_ movie: BasicMovieInfo) -> some View {
        NavigationLink {
            DetailMovieInfoView()
        } label: {
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
