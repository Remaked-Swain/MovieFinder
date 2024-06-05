//
//  DetailMovieView.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/4/24.
//

import SwiftUI
import Combine

struct DetailMovieInfoView<ViewModel: MovieListViewModel>: View {
    @ObservedObject private var vm: ViewModel
    private let code: String
    
    init(vm: ViewModel, code: String) {
        self.vm = vm
        self.code = code
    }
    
    var body: some View {
        ScrollView(.vertical) {
            if let movieInfo = vm.selectedMovieInfo {
                VStack(alignment: .listRowSeparatorLeading, spacing: 10) {
                    Text(movieInfo.movieName)
                        .font(.largeTitle)
                    
                    Text("개봉 연월일: \(movieInfo.openDate)")
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                ForEach(movieInfo.actors, id: \.id) { `actor` in
                    HStack(spacing: 10) {
                        if actor.cast.isEmpty == false {
                            Text("\(actor.cast)역")
                                .bold()
                        }
                        
                        Text("\(actor.peopleName)")
                    }
                }
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .onAppear {
            vm.updateDetailMovieInfo(movieCode: code)
        }
        .onDisappear {
            vm.flushMovieInfo()
        }
    }
}
