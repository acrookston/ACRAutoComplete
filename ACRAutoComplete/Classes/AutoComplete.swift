//
//  AutoComplete.swift
//
//  Created by Andrew C on 9/19/16.
//
//

import Foundation

public protocol Searchable: Hashable {
    var keywords: [String] { get }
}

open class AutoComplete<T : Searchable> {
    lazy var nodes = [Character : AutoComplete<T>]()
    lazy var items = [T]()

    public init() { }

    // MARK: - Insert / index

    public func insert(_ object: T) {
        for string in object.keywords {
            var tokens = tokenize(string)
            var at = 0
            var max = tokens.count
            insert(&tokens, at: &at, max: &max, object: object)
        }
    }

    private func insert(_ tokens: inout [Character], at: inout Int, max: inout Int, object: T) {
        if at < max {
            let current = tokens[at]
            at += 1

            if nodes[current] == nil {
                nodes[current] = AutoComplete<T>()
            }

            nodes[current]?.insert(&tokens, at: &at, max: &max, object: object)
        } else {
            items.append(object)
        }
    }

    public func insert(_ set: [T]) {
        for object in set {
            insert(object)
        }
    }

    // MARK: - Search

    public func search(_ string: String) -> [T] {
        var merged: Set<T>?

        for word in string.components(separatedBy: " ") {
            var wordResults = Set<T>()
            var tokens = tokenize(word)
            var count = tokens.count
            var at = 0
            find(&tokens, at: &at, max: &count, into: &wordResults)
            if let results = merged {
                merged = results.intersection(wordResults)
            } else {
                merged = wordResults
            }
        }

        if let results = merged {
            return Array(results)
        }
        return []
    }

    private func find(_ tokens: inout [Character], at: inout Int, max: inout Int, into results: inout Set<T>) {
        if at < max {
            let current = tokens[at]
            at += 1
            nodes[current]?.find(&tokens, at: &at, max: &max, into: &results)
        } else {
            insertAll(into: &results)
        }
    }

    func insertAll(into results: inout Set<T>) {
        for t in items {
            results.insert(t)
        }

        for (_, child) in nodes {
            child.insertAll(into: &results)
        }
    }

    private func tokenize(_ string: String) -> [Character] {
        return Array(string.lowercased().characters)
    }
}
