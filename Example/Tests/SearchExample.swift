//
//  SearchExample.swift
//
//  Created by Andrew C on 9/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ACRAutoComplete

class SearchExample: Searchable {

    var name: String
    var words: [String]

    init(name: String, words: [String]) {
        self.name = name
        self.words = words
    }

    func keywords() -> [String] {
        return words
    }

    // MARK: - Hashable

    var hashValue: Int { return name.hashValue }

    static func == (lhs: SearchExample, rhs: SearchExample) -> Bool {
        return lhs.name == rhs.name
    }
}
