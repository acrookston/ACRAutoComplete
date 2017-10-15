//
//  SearchExample.swift
//
//  Created by Andrew C on 9/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import ACRAutoComplete

final class SearchExample: Searchable {

    var name: String
    var keywords: [String]

    init(name: String, keywords: [String]) {
        self.name = name
        self.keywords = keywords
    }

    // MARK: - Hashable

    var hashValue: Int { return name.hashValue }

    static func == (lhs: SearchExample, rhs: SearchExample) -> Bool {
        return lhs.name == rhs.name
    }
}
