//
//  DetailMovieInfo.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/3/24.
//

import Foundation

struct DetailMovieInfo {
    let movieCode, movieName, movieNameOriginal: String
    let showTime, productYear, openDate: String
    let typeName: String
    let nations: [Nation]
    let genres: [Genre]
    let directors: [Director]
    let actors: [Actor]
    let companys: [Company]
    let audits: [Audit]
    let staffs: [Staff]
}
