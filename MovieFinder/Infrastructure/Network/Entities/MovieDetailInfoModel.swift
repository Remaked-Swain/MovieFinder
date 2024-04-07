import Foundation

struct MovieDetailInfoModel: Decodable {
    let movieInfoResult: MovieInfoResult
}

struct MovieInfoResult: Decodable {
    let movieInfo: MovieInfo
    let source: String
}

struct MovieInfo: Decodable {
    let movieCode, movieName, movieNameEnglish, movieNameOriginal: String
    let showTime, productYear, openDate, productStateName: String
    let typeName: String
    let nations: [Nation]
    let genres: [Genre]
    let directors: [Director]
    let actors: [Actor]
    let showTypes: [ShowType]
    let companys: [Company]
    let audits: [Audit]
    let staffs: [Staff]

    enum CodingKeys: String, CodingKey {
        case movieCode = "movieCd"
        case movieName = "movieNm"
        case movieNameEnglish = "movieNmEn"
        case movieNameOriginal = "movieNmOg"
        case showTime = "showTm"
        case productYear = "prdtYear"
        case openDate = "openDt"
        case productStateName = "prdtStatNm"
        case typeName = "typeNm"
        case nations, genres, directors, actors, showTypes, companys, audits, staffs
    }
    
    func toDTO() -> DetailMovieInfo {
        return DetailMovieInfo(
            movieCode: movieCode,
            movieName: movieName,
            movieNameOriginal: movieNameOriginal,
            showTime: showTime,
            productYear: productYear,
            openDate: openDate,
            typeName: typeName,
            nations: nations,
            genres: genres,
            directors: directors,
            actors: actors,
            companys: companys,
            audits: audits,
            staffs: staffs
        )
    }
}

struct Actor: Decodable {
    let peopleName, peopleNameEnglish, cast, castEnglish: String
    
    enum CodingKeys: String, CodingKey {
        case peopleName = "peopleName"
        case peopleNameEnglish = "popleNmEn"
        case castEnglish = "castEn"
        case cast
    }
}

struct Audit: Decodable {
    let auditNumber, watchGradeName: String
    
    enum CodingKeys: String, CodingKey {
        case auditNumber = "auditNo"
        case watchGradeName = "watchGradeNm"
    }
}

struct Company: Decodable {
    let companyCode, companyName, companyNameEnglish, companyPartName: String

    enum CodingKeys: String, CodingKey {
        case companyCode = "companyCd"
        case companyName = "companyNm"
        case companyNameEnglish = "companyNmEn"
        case companyPartName = "companyPartNm"
    }
}

struct Director: Decodable {
    let peopleName, peopleNameEnglish: String
    
    enum CodingKeys: String, CodingKey {
        case peopleName = "peopleNm"
        case peopleNameEnglish = "peopleNmEn"
    }
}

struct Genre: Decodable {
    let genreName: String
    
    enum CodingKeys: String, CodingKey {
        case genreName = "genreNm"
    }
}

struct Nation: Decodable {
    let nationName: String
    
    enum CodingKeys: String, CodingKey {
        case nationName = "nationNm"
    }
}

struct ShowType: Decodable {
    let showTypeGroupName, showTypeName: String
    
    enum CodingKeys: String, CodingKey {
        case showTypeGroupName = "showTypeGroupNm"
        case showTypeName = "showTypeNm"
    }
}

struct Staff: Decodable {
    let peopleName, peopleNameEnglish, staffRoleName: String
    
    enum CodingKeys: String, CodingKey {
        case peopleName = "peopleNm"
        case peopleNameEnglish = "peopleNmEn"
        case staffRoleName = "staffRoleNm"
    }
}
