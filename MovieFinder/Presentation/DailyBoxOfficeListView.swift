//
//  ContentView.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import SwiftUI

final class DailyBoxOfficeListViewModel: ObservableObject {
    // MARK: Dependencies
    private let fetchDailyBoxOfficeUseCase: FetchDailyBoxOfficeListUseCase
    
    // MARK: Properties
    @Published var dailyBoxOfficeList: [DailyBoxOfficeList] = []
    
    init(fetchDailyBoxOfficeUseCase: FetchDailyBoxOfficeListUseCase) {
        self.fetchDailyBoxOfficeUseCase = fetchDailyBoxOfficeUseCase
    }
    
    func updateDailyBoxOfficeList() {
        Task {
            guard let dailyBoxOfficeList = try? await fetchDailyBoxOfficeUseCase.fetchDailyBoxOfficeList() else {
                dailyBoxOfficeList = []
                return
            }
            self.dailyBoxOfficeList = dailyBoxOfficeList
        }
    }
}

struct DailyBoxOfficeListView: View {
    @ObservedObject private var vm: DailyBoxOfficeListViewModel
    
    init(vm: DailyBoxOfficeListViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        List(vm.dailyBoxOfficeList, id: \.movieCode) { movie in
            HStack {
                Text(movie.movieName)
            }
        }
        .onAppear {
            vm.updateDailyBoxOfficeList()
        }
    }
}

#Preview {
    DailyBoxOfficeListView(vm: DailyBoxOfficeListViewModel(fetchDailyBoxOfficeUseCase: DefaultFetchDailyBoxOfficeListUseCase(repository: DefaultDailyBoxOfficeListRepository(networkService: DefaultNetworkService(sessionManager: DefaultNetworkSessionManager())))))
}
