//
//  Date.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import Foundation

extension Date {
    var asEightPlaceString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let formatted = formatter.string(from: self)
        return formatted
    }
}
