//
//  FetchArticles.swift
//  PirateTimes
//
//  Created by Edmund Trujillo on 11/18/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// unique sentence delimiter used to combine NY Times snippets
private let sentenceDelimiter:String = "~~~"

// Because we get charged for each API call for the pirate translation we're going to
// optimize and combine all of the snippets into ONE long string and then translate
// that string.  This means we have to combine and uncombine the articles.

// we make 2 calls - one to fetch the NYTimes articles from the search term and
// the second one to call the pirate translation API.  This is the only public entry
// point for the FetchArticles module
func fetchArticles(_ searchTerm: String?, _ completion:@escaping ([Article]?) -> Void) {
    
    guard let path = nyTimesUrl(searchTerm) else { return }
    
    Alamofire.request(path, headers:nil).responseJSON { response in
        if let alamoJson = response.result.value {
            let swiftJson = JSON(alamoJson)
            
            let docs = swiftJson["response"]["docs"].array!
            var articles = [Article]()
            
            for doc in docs {
                let article = parseNYTimesArticle(docJson: doc)
                if let article = article {
                    articles.append(article)
                }
            }
            
            translateArticles(articles: articles, { (returnedArticles ) in
                completion(returnedArticles)
            })
        } else {
            completion(nil)
        }
    }
}

// MARK: - Private functions


// The pirate translation requires a POST request and that the text be passed in the
// httpBody.  Here is where we combine the snippets to a single line with delimiters

private func translateArticles(articles: [Article], _ completion:@escaping ([Article]?) -> Void) {
    
    guard let path = pirateUrl() else { return }
    let headers = pirateRequestHeader()
    
    let url = URL(string: path)!
    var urlRequest : URLRequest
    
    urlRequest = try! URLRequest(url: url, method: .post, headers: headers)
    
    let largeLineToTranslate = combineSnippetsToSingleTranslatedLine(articles: articles)
    let strparam = "text=" + largeLineToTranslate
    
    urlRequest.httpBody = strparam.data(using: .utf8)
    
    Alamofire.request(urlRequest).responseJSON { response in
        if let alamoJson = response.result.value {
            let swiftJson = JSON(alamoJson)
            
            let translatedText = swiftJson["contents"]["translated"].string
            if let translatedText = translatedText {
                let newArticles = uncombineSingleTranslatedLineToSnippets(line: translatedText, articles: articles)
                
                completion(newArticles)
            }
        } else {
            completion(nil)
        }
    }
}

// MARK: - Combine/uncombine snippets

private func combineSnippetsToSingleTranslatedLine(articles: [Article]) -> String {
    var str = String()
    
    for article in articles {
        if article.englishText.isEmpty {
            str.append(" ")
        } else {
            str.append(article.englishText)
        }
        str.append(sentenceDelimiter)
    }
    
    return str
}

private func uncombineSingleTranslatedLineToSnippets(line: String, articles: [Article])-> [Article] {
    var translatedArticles = [Article]()
    
    var separatedLines = line.components(separatedBy: sentenceDelimiter)
    
    var index = 0
    for article in articles {
        let id = article.id
        let webUrl = article.webUrl
        let englishText = article.englishText
        let pirateText: String?
        
        // in case the translator didn't translate all lines ... just fill in the remaining snippets with english
        if index < separatedLines.count {
            pirateText = separatedLines[index]
        } else {
            pirateText = englishText
        }
        let thumbUrl = article.thumbUrl
        
        let newArticle = Article(id: id, webUrl: webUrl, englishText: englishText, pirateText: pirateText!, thumbUrl: thumbUrl)
        
        translatedArticles.append(newArticle)
        index += 1
    }
    
    return translatedArticles
}

// MARK: - NY Times JSON to Article

private func parseNYTimesArticle(docJson: JSON) -> Article? {
    
    // must have a snippet, webURL and ID otherwise skip
    guard let snippet = docJson["snippet"].string else { return nil }
    guard let webUrl = docJson["web_url"].string else { return nil }
    guard let id = docJson["_id"].string else { return nil }
    
    // reject any story that doesn't have a snippet 
    if snippet.isEmpty {
        return nil
    }
    
    let multiMediaFiles = docJson["multimedia"].array
    var thumbnailUrl: String? = nil
    
    // search for thumbnail in json response
    if let mediaFiles = multiMediaFiles {
        for mediaFile in mediaFiles {
            let type = mediaFile["type"].stringValue
            let subType = mediaFile["subtype"].stringValue
            
            if type == "image" && subType == "thumbnail" {
                thumbnailUrl = mediaFile["url"].string
                break
            }
        }
    }
    
    // finally instantiate the article ... leave the untranslated pirate text blank for now as that
    // will get called in a subsequent network call to a different service
    let article = Article(id: id, webUrl: webUrl, englishText: snippet, pirateText: "", thumbUrl: thumbnailUrl)
    
    return article
}

