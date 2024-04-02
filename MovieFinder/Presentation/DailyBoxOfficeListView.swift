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
    @Published var dailyBoxOfficeList: [DailyBoxOfficeList] = []
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
                self?.dailyBoxOfficeList = value
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
    DailyBoxOfficeListView(vm: DailyBoxOfficeListViewModel(fetchDailyBoxOfficeListUseCase: DefaultFetchDailyBoxOfficeListUseCase(repository: DefaultDailyBoxOfficeListRepository(networkService: DefaultNetworkService(sessionManager: DefaultNetworkSessionManager())))))
}
