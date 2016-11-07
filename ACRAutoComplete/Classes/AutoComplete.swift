//
//  AutoComplete.swift
//
//  Created by Andrew C on 9/19/16.
//
//

import Foundation

public protocol Searchable : Hashable {
    func keywords() -> [String]
}

open class AutoComplete<T : Searchable> {

    var nodes : [Character : AutoComplete<T>]?
    var items  : [T]?

    public init() { }

    public func insert(_ object: T) {
        for string in object.keywords() {
            var tokens = tokenize(string)
            var at = 0
            var max = tokens.count
            insert(&tokens, at: &at, max: &max, object: object)
        }
    }

    public func insert(set: [T]) {
        for object in set {
            insert(object)
        }
    }

    public func search(_ string: String) -> [T] {
        var mergedResults : Set<T>?

        for word in string.components(separatedBy: " ") {
            var wordResults = Set<T>()
            var tokens = tokenize(word)
            find(&tokens, into: &wordResults)
            if mergedResults == nil {
                mergedResults = wordResults
            } else {
                mergedResults = mergedResults!.intersection(wordResults)
            }
        }

        return mergedResults == nil ? [] : Array(mergedResults!)
    }

    func insertAll(into results: inout Set<T>) {
        if let items = items {
            for t in items {
                results.insert(t)
            }
        }

        guard let nodes = nodes else {
            return
        }

        for (_, child) in nodes {
            child.insertAll(into: &results)
        }
    }

    private func find(_ tokens : inout [Character], into results: inout Set<T>) {
        guard tokens.count > 0 else {
            insertAll(into: &results)
            return
        }

        guard let nodes = nodes else {
            return
        }

        let current = tokens.remove(at: 0)

        nodes[current]?.find(&tokens, into: &results)
    }

    private func insert(_ tokens: inout [Character], at: inout Int, max: inout Int, object: T) {
        if at < max {
            let next = tokens[at]
            at += 1

            if nodes == nil {
                nodes = [Character : AutoComplete<T>]()
            }
            if nodes![next] == nil {
                nodes![next] = AutoComplete<T>()
            }
            nodes![next]!.insert(&tokens, at: &at, max: &max, object: object)
        } else {
            if items == nil {
                items = [T]()
            }
            items!.append(object)
        }
    }

    private func tokenize(_ string: String) -> [Character] {
        return Array(string.lowercased().characters)
    }

//    // MARK: - NSCoding
//
//    let codingKeyNodes = "nodes"
//    let codingKeyItems = "items"
//
//    public func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.children, forKey: codingKeyChildren)
//        aCoder.encode(self.children, forKey: codingKeyItems)
//    }
//
//    required convenience public init?(coder decoder: NSCoder) {
//        self.init()
//        children = decoder.decodeObject(forKey: codingKeyChildren) as? [Character : AutoComplete<T>]
//        items = decoder.decodeObject(forKey: codingKeyItems) as? [T]
//    }
//
//    func encodeWithCoder(coder: NSCoder) {
//        coder.encode(self.children, forKey: codingKeyChildren)
//        coder.encode(self.children, forKey: codingKeyItems)
//    }
}
