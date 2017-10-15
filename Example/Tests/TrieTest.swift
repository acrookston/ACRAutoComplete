//
//  TrieTest.swift
//  ACRAutoComplete
//
//  Created by Andrew C on 9/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import ACRAutoComplete

class AutoCompleteTest: XCTestCase {

    var trie: AutoComplete<SearchExample>!

    override func setUp() {
        super.setUp()
        print("running setup")

        trie = AutoComplete<SearchExample>()
    }

    override func tearDown() {
        super.tearDown()
        print("running teardown")
    }

    func testSearchShouldFindBall() {
        let football = SearchExample(name: "Football", keywords: ["ball"])
        trie.insert(football)

        XCTAssert(trie.search("Ball").contains(football), "Contains Football")
    }

    func testSearchShouldHaveMultipleResults() {
        let soccer = SearchExample(name: "Soccer", keywords: ["ball"])
        let football = SearchExample(name: "Football", keywords: ["ball"])
        trie.insert([soccer, football])

        let results = trie.search("ball")
        XCTAssert(results.contains(soccer), "Contains soccer")
        XCTAssert(results.contains(football), "Contains Football")
    }

    func testSearchSearchShouldFindLongerWords() {
        // This tests to make sure "Foot" matches against "Football"
        let ball = SearchExample(name: "Ball", keywords: ["football"])
        trie.insert(ball)

        XCTAssert(trie.search("Foot").count == 1, "Contains Foot as part of football")
    }

    func testSearchSearchShouldFindInSeveralWords() {
        // This tests to make sure "Foot" matches against "Football"
        let smile = SearchExample(name: "Smile", keywords: ["happy", "silly"])
        trie.insert(smile)

        XCTAssert(trie.search("ha").count == 1, "Contains happy as partial search ha for happy")
        XCTAssert(trie.search("si").count == 1, "Contains happy as partial search si for silly")
    }

    func testSearchShouldNotFindShorterWords() {
        // This tests to make sure "Football" does not match against "foot"
        let ball = SearchExample(name: "Ball", keywords: ["foot"])
        trie.insert(ball)

        XCTAssert(trie.search("Football").isEmpty, "Does not contain Football")
    }

    func testSearchShouldOnlyFindMatchesWhichIncludeAllWords() {
        let soccer = SearchExample(name: "Soccer", keywords: ["soccer", "ball"])
        let football = SearchExample(name: "Football", keywords: ["foot", "ball"])
        trie.insert([soccer, football])

        let results = trie.search("foot ball")
        XCTAssert(results.count == 1, "Only contains one result")
        XCTAssert(results.first == football, "Contains Football")
    }
}
