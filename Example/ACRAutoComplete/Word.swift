//
//  SearchExample.swift
//
//  Created by Andrew C on 9/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ACRAutoComplete

final class Word: Searchable {
    var word: String
    var keywords: [String] { return [word] }

    init(word: String) {
        self.word = word
    }
}

extension Word : Hashable {
    var hashValue: Int { return word.hashValue }

    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.word == rhs.word
    }
}
