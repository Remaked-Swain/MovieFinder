//
//  ContentView.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import SwiftUI

struct DailyBoxOfficeListView<ViewModel: MovieListViewModel>: View {
    @ObservedObject private var vm: ViewModel
    
    private let navigationTitle: String = "일일 박스오피스 순위"
    
    init(vm: ViewModel) {
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
            DetailMovieInfoView(vm: vm, code: movie.movieCode)
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
