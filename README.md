# ACRAutoComplete

### A text search and auto-completion library written in Swift for iOS.

[![CI Status](http://img.shields.io/travis/acrookston/ACRAutoComplete.svg?style=flat)](https://travis-ci.org/acrookston/ACRAutoComplete)
[![Version](https://img.shields.io/cocoapods/v/ACRAutoComplete.svg?style=flat)](http://cocoapods.org/pods/ACRAutoComplete)
[![License](https://img.shields.io/cocoapods/l/ACRAutoComplete.svg?style=flat)](http://cocoapods.org/pods/ACRAutoComplete)
[![Platform](https://img.shields.io/cocoapods/p/ACRAutoComplete.svg?style=flat)](http://cocoapods.org/pods/ACRAutoComplete)
[![codebeat badge](https://codebeat.co/badges/0f4314a5-4d04-4c30-b741-561782b595e9)](https://codebeat.co/projects/github-com-acrookston-acrautocomplete)
[![codecov](https://codecov.io/gh/acrookston/ACRAutoComplete/branch/master/graph/badge.svg)](https://codecov.io/gh/acrookston/ACRAutoComplete)


Index and quickly search Swift objects for specific words. Based on a [Trie](https://en.wikipedia.org/wiki/Trie) data structure.

The library does not include a user interface, however there is a full working UI in the Example code. Originally this was written for [MessMoji](http://messmoji.com).


## Metrics

A SOWPODS word list is used for testing and contains 267753 words.

Via iOS Simulator on a Macbook Pro 13" 2.4 GHz Intel Core i5 8GB, index time is roughly 5 seconds and searching usually takes 200ms or less.


## Author

Andrew Crookston [@acr](https://twitter.com/acr)

Tweet me if you like this library, have questions or feedback.


## Contributing

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

Bug reports and pull requests are welcome via GitHub at https://github.com/acrookston/ACRAutoComplete.

You will need [SwiftLint](https://github.com/realm/SwiftLint) installed for the build process to pass.

If you're making a big change, please open an Issue first, so we can discuss. Otherwise:

- Fork the repo
- Open `Example/ACRAutoComplete.workspace`
- Make your changes
- Confirm tests are passing
- Confirm no SwiftLint passes (no Xcode warnings).


## Example Project

The Example project contains a fully working implementation with a simple user interface to search the SOWPODS word list.

To run the example project, clone the repo, and run `pod install` from the Example directory before running.


## Requirements

The library was written for iOS and has no external requirements. It's possible it will work on macOS or other Swift platforms, but has not been tested.

Built for:

- Swift 3 or 4
- iOS 8+

## Installation

ACRAutoComplete is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "ACRAutoComplete"
```

Swift 3 legacy support through the `swift-3` branch:
```ruby
pod "ACRAutoComplete", git: "https://github.com/acrookston/ACRAutoComplete", branch: "swift-3"
```

Support for Carthage and SPM is on the way (and a good place to add your contribution).


## Usage

First add the protocol to whatever object you wish to index, for example with a `Word` class, and add the required methods:

```swift
import ACRAutoComplete

class Word: Searchable {
    let word: String
    init(_ word: String) {
        self.word = word
    }

    // From Searchable protocol
    var keywords: [String] {
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


## License

ACRAutoComplete is available under the MIT license. See the LICENSE file for more info.

The example project (not the framework) includes a SOWPODS word file which is used for testing. The license of the SOWPODS file when downloaded was unknown but was labeled "open source".
