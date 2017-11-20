//
//  PigLatin.swift
//  PirateTimes
//
//  Created by Edmund Trujillo on 11/19/17.
//  Copyright © 2017 Edmund Trujillo. All rights reserved.
//

import Foundation

// Simple English to Pig-Latin conversion that I wrote.  This is not an endpoint ... it takes
// an english sentence and returns a new sentence that has been translated to Pig-Latin

func convertEnglishToPigLatin(sentence: String) -> String {
    
    let trimmedSentence = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
    let words = trimmedSentence.components(separatedBy:.whitespacesAndNewlines)
    var translatedWords = [String]()
    
    for word in words {
        if !word.isEmpty {
            let translatedWord = convertWordToPigLatin(word.trimmingCharacters(in: CharacterSet.whitespaces))
            translatedWords.append(translatedWord)
        }
    }
    
    return translatedWords.joined(separator: " ")
}


private func convertWordToPigLatin(_ word: String) -> String {
    
    let firstChar = word[word.startIndex]
    let firstStr = "\(firstChar)"
    
    if isVowel(firstStr) {
        return word + "way"
    }
    
    let split = splitWordInto(word)
    
    return split.suffix + split.prefix + "ay" + split.punc
}

private func isVowel(_ ch: String) -> Bool {
    let vowels = ["a", "e", "i", "o", "u", "y", "A", "E", "I", "O", "U", "Y"]
    return vowels.contains(ch)
}

private func splitWordInto(_ word: String) -> (prefix:String, suffix:String, punc:String) {
    var leadingConsonants = String()
    var lastConsonantIndex = word.startIndex
    
    for i in 0 ..< word.count {
        let index = word.index(word.startIndex, offsetBy: i)
        let ch = word[index]
        let chStr = "\(ch)"
        
        if !isVowel(chStr) {
            leadingConsonants.append(chStr)
            lastConsonantIndex = word.index(word.startIndex, offsetBy: i+1)
        } else {
            break;
        }
    }
    
    var remaining = word[lastConsonantIndex..<word.endIndex]
    
    let punct = remaining.rangeOfCharacter(from: CharacterSet.punctuationCharacters)
    
    var punctuation = String()
    if punct != nil {
        punctuation = remaining.trimmingCharacters(in: CharacterSet.alphanumerics)
        let trimmedstr = String(remaining).trimmingCharacters(in: CharacterSet.punctuationCharacters)
        remaining = Substring(trimmedstr)
    }
    
    return (prefix:leadingConsonants, suffix:String(remaining), punc:String(punctuation))
}


