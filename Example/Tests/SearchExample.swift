//
//  SearchExample.swift
//
//  Created by Andrew C on 9/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ACRAutoComplete

class SearchExample : Searchable {

    var id : String
    var words : [String]

    init(id: String, words: [String]) {
        self.id = id
        self.words = words
    }

    func keywords() -> [String] {
        return words
    }

    //MARK: - Hashable

    var hashValue: Int { return id.hashValue }

    static func == (lhs: SearchExample, rhs: SearchExample) -> Bool {
        return lhs.id == rhs.id
    }
}
