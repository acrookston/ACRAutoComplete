Pod::Spec.new do |s|
  s.name             = 'ACRAutoComplete'
  s.version          = '1.1.1'
  s.summary          = 'An auto-complete library written in Swift for iOS using the trie data structure'

  s.description      = <<-DESC
  An auto-complete library written in Swift for iOS using the trie data structure.

  A simple Trie structure implementation in Swift for indexing and searching words.

  This library does not include a user interface, it was built to be a simple easy to use auto-completion tool. Originally, it written for MessMoji.
                       DESC

  s.homepage         = 'https://github.com/acrookston/ACRAutoComplete'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andrew Crookston' => 'andrew@caoos.com' }
  s.source           = { :git => 'https://github.com/acrookston/ACRAutoComplete.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/acr'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ACRAutoComplete/Classes/**/*'
end
