//
//  MovieFinderApp.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import SwiftUI

private let sessionManager = DefaultNetworkSessionManager()
private let networkService = DefaultNetworkService(sessionManager: sessionManager)
private let dailyBoxOfficeListRepository = DefaultDailyBoxOfficeListRepository(networkService: networkService)
private let fetchDailyBoxOfficeUseCase = DefaultFetchDailyBoxOfficeListUseCase(repository: dailyBoxOfficeListRepository)
private let fetchMovieDetailUseCase = DefaultFetchMovieDetailUseCase(repository: dailyBoxOfficeListRepository)

@main
struct MovieFinderApp: App {
    private let dailyBoxOfficeListViewModel = DailyBoxOfficeListViewModel(fetchDailyBoxOfficeListUseCase: fetchDailyBoxOfficeUseCase)
    private let detailMovieInfoViewModel = DetailMovieInfoViewModel(fetchMovieDetailUseCase: fetchMovieDetailUseCase)
    
    var body: some Scene {
        WindowGroup {
            DailyBoxOfficeListView(vm: dailyBoxOfficeListViewModel)
        }
    }
}
