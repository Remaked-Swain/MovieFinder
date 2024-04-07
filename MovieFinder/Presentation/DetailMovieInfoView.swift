//
//  DetailMovieView.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/4/24.
//

import SwiftUI

final class DetailMovieInfoViewModel: ObservableObject {
    private let fetchMovieDetailUseCase: FetchMovieDetailUseCase
    
    init(fetchMovieDetailUseCase: FetchMovieDetailUseCase) {
        self.fetchMovieDetailUseCase = fetchMovieDetailUseCase
    }
}

struct DetailMovieInfoView: View {
    var body: some View {
        Text("")
    }
}
