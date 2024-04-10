//
//  DetailMovieView.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/4/24.
//

import SwiftUI
import Combine

struct DetailMovieInfoView: View {
    @ObservedObject private var vm: DetailMovieInfoViewModel
    @Binding var code: String?
    
    init(vm: DetailMovieInfoViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        Text("")
            .onAppear {
                vm.updateDetailMovieInfo(code: code)
            }
    }
}
