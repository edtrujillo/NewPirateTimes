//
//  Constants.swift
//  PirateTimes
//
//  Created by Edmund Trujillo on 11/18/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

import Foundation

enum LanguageConversion {
    case PirateLanguage
    case EnglishLanguage
    case PigLatinLanguage
}

fileprivate struct Constants {
    static let nyTimesAPIKey: String = "5416bc8a024347a5ba426147197619ca"
    static let pirateAPIKey: String = "Brf_KqU46cxy2MqLeJmS0QeF"
    
    static let nyTimesSearch1: String = "https://api.nytimes.com/svc/search/v2/articlesearch.json?fq="
    static let nyTimesSearch2: String = "&facet_field=day_of_week&begin_date=20170101&end_date=20171111&api-key="
    
    static let pirateRequestQuery: String = "http://api.funtranslations.com/translate/pirate.json"
    static let pirateApiHeader: String = "X-Funtranslations-Api-Secret"
}

func nyTimesUrl(_ searchTerm: String?) -> String? {
    
    guard let sanitizedName = searchTerm?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
        return nil
    }

    return Constants.nyTimesSearch1 + sanitizedName + Constants.nyTimesSearch2 + Constants.nyTimesAPIKey
}

func pirateRequestHeader() -> [String:String] {
    return [Constants.pirateApiHeader: Constants.pirateAPIKey]
}

func pirateUrl() -> String? {
    return Constants.pirateRequestQuery
}

