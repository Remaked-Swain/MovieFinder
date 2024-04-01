//
//  MovieFinderApp.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import SwiftUI

//DailyBoxOfficeListView(
//    vm: DailyBoxOfficeListViewModel(
//        fetchDailyBoxOfficeUseCase: DefaultFetchDailyBoxOfficeListUseCase(
//            repository: DefaultDailyBoxOfficeListRepository(
//                networkService: DefaultNetworkService(
//                    sessionManager: DefaultNetworkSessionManager())))))

private let sessionManager = DefaultNetworkSessionManager()
private let networkService = DefaultNetworkService(sessionManager: sessionManager)
private let dailyBoxOfficeListRepository = DefaultDailyBoxOfficeListRepository(networkService: networkService)
private let fetchDailyBoxOfficeUseCase = DefaultFetchDailyBoxOfficeListUseCase(repository: dailyBoxOfficeListRepository)

@main
struct MovieFinderApp: App {
    private let dailyBoxOfficeListViewModel = DailyBoxOfficeListViewModel(fetchDailyBoxOfficeUseCase: fetchDailyBoxOfficeUseCase)
    
    var body: some Scene {
        WindowGroup {
            DailyBoxOfficeListView(vm: dailyBoxOfficeListViewModel)
        }
    }
}
