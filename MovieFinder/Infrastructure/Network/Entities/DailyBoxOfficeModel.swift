//
//  DailyBoxOfficeModel.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import Foundation

struct DailyBoxOfficeModel: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Decodable {
    let rotationNumber, rank, rankIntensity: String
    let rankOldAndNew: RankOldAndNew
    let movieCode, movieName, openDate, salesAmount: String
    let salesShare, salesIntensity, salesChange, salesAccumulatedAmount: String
    let audienceCount, audienceIntensity, audienceChange, audienceAccumulatedAmount: String
    let screenCount, showCount: String

    enum CodingKeys: String, CodingKey {
        case rank, rankOldAndNew, salesShare, salesChange
        case rotationNumber = "rnum"
        case rankIntensity = "rankInten"
        case movieCode = "movieCd"
        case movieName = "movieNm"
        case openDate = "openDt"
        case salesAmount = "salesAmt"
        case salesIntensity = "salesInten"
        case salesAccumulatedAmount = "salesAcc"
        case audienceCount = "audiCnt"
        case audienceIntensity = "audiInten"
        case audienceChange = "audiChange"
        case audienceAccumulatedAmount = "audiAcc"
        case screenCount = "scrnCnt"
        case showCount = "showCnt"
    }
}

enum RankOldAndNew: String, Decodable {
    case old = "OLD"
    case new = "NEW"
}
