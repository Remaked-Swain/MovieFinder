//
//  MovieFinderApp.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import SwiftUI

@main
struct MovieFinderApp: App {
    private let container: AppDependencyContainer = {
        let container: AppDependencyContainer = DefaultDependencyContainer()
        container.register(for: DefaultNetworkSessionManager.self, instance: DefaultNetworkSessionManager())
        container.register(for: DefaultNetworkService.self) { resolver in
            DefaultNetworkService(sessionManager: resolver.resolve(for: DefaultNetworkSessionManager.self))
        }
        container.register(for: DefaultDailyBoxOfficeListRepository.self) { resolver in
            DefaultDailyBoxOfficeListRepository(networkService: resolver.resolve(for: DefaultNetworkService.self))
        }
        container.register(for: DefaultFetchDailyBoxOfficeListUseCase.self) { resolver in
            DefaultFetchDailyBoxOfficeListUseCase(repository: resolver.resolve(for: DefaultDailyBoxOfficeListRepository.self))
        }
        container.register(for: DefaultFetchMovieDetailUseCase.self) { resolver in
            DefaultFetchMovieDetailUseCase(repository: resolver.resolve(for: DefaultDailyBoxOfficeListRepository.self))
        }
        container.register(for: DefaultMovieListViewModel.self) { resolver in
            DefaultMovieListViewModel(fetchDailyBoxOfficeListUseCase: resolver.resolve(for: DefaultFetchDailyBoxOfficeListUseCase.self), fetchMovieDetailUseCase: resolver.resolve(for: DefaultFetchMovieDetailUseCase.self))
        }
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DailyBoxOfficeListView(vm: container.resolve(for: DefaultMovieListViewModel.self))
            }
        }
    }
}
