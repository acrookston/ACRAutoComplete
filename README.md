# ACRAutoComplete

### An auto-complete text library for iOS.

[![CI Status](http://img.shields.io/travis/acrookston/ACRAutoComplete.svg?style=flat)](https://travis-ci.org/acrookston/ACRAutoComplete)
[![Version](https://img.shields.io/cocoapods/v/ACRAutoComplete.svg?style=flat)](http://cocoapods.org/pods/ACRAutoComplete)
[![License](https://img.shields.io/cocoapods/l/ACRAutoComplete.svg?style=flat)](http://cocoapods.org/pods/ACRAutoComplete)
[![Platform](https://img.shields.io/cocoapods/p/ACRAutoComplete.svg?style=flat)](http://cocoapods.org/pods/ACRAutoComplete)
[![codebeat badge](https://codebeat.co/badges/0f4314a5-4d04-4c30-b741-561782b595e9)](https://codebeat.co/projects/github-com-acrookston-acrautocomplete)

A simple Trie structure implementation in Swift for indexing and searching words.

This library does not include a user interface, it was built to be a simple easy to use auto-completion tool. Originally, it written for [MessMoji](http://messmoji.com).


## Author

Andrew Crookston

Please send me a tweet if you like this library or have questions or feedback: [@acr](https://twitter.com/acr)


## Example

The Example project contains a full working implementation of the library including a table view, and an input field to search the SOWPODS word list. If you are looking for an auto-complete solution with a UI, take a look at the Example project.

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Requirements

The library was written for iOS. It has no external requirements and it's possible it works on macOS or other Swift platforms, but this has not been tested.


## Installation

ACRAutoComplete is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "ACRAutoComplete"
```

## Usage

First add the protocol to whatever object you wish to index, for example with a `Word` class, and add the required methods:

```swift
import ACRAutoComplete

class Word : Searchable {
    let word : String
    init(_ word: String) {
        self.word = word
    }

    // From Searchable protocol
    func keywords() -> [String] {
        return [word]
    }

    // Hashable
    var hashValue: Int { return word.hashValue }

    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.id == rhs.id
    }
}
```

In your controller or place where you wish to use the index. Create an `AutoComplete` object with the `Word` class:
```swift
let autocomplete = AutoComplete<Word>()
```

Insert the objects you wish to index:
```swift
let football = Word("Football")
autocomplete.insert(football)
```

Finally, when needed, search the index for any matching objects:
```swift
autocomplete.search("foot") // -> [Word("Football")]
```

## Metrics

For testing, the SOWPODS word list has been used. It contains 267753 words which takes roughly 5 seconds to index in the iOS Simulator. Searching is very quick and will take less than 200ms, depeding .

## License

ACRAutoComplete is available under the MIT license. See the LICENSE file for more info.

The example project (not the Pod) includes a SOWPODS word file which is used for testing. The license of the SOWPODS file when downloaded was unknown but was labeled "open source".
