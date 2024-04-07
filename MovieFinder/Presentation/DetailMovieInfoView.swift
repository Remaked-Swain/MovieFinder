//
//  DetailMovieView.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/4/24.
//

import SwiftUI

//final class DetailMovieView

struct DetailMovieInfoView: View {
    @Binding var detailMovieInfo: DetailMovieInfo?
    
    var body: some View {
        Text(detailMovieInfo?.movieName ?? "없음")
    }
}
