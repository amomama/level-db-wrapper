#
# Be sure to run `pod lib lint level-db-wrapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'level-db-wrapper'
  s.version          = '0.1.0'
  s.summary          = 'A short description of level-db-wrapper.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ivan-genesis/level-db-wrapper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ivan-genesis' => 'ivan.sinitsa@gen.tech' }
  s.source           = { :git => 'https://github.com/ivan-genesis/level-db-wrapper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.3'
  s.platform     = :ios, "10.3"

  s.source_files  = "Classes", "level-db-wrapper/LevelDBForSwift/**/*.{swift,hpp,cpp,h,m}"
  s.public_header_files = "level-db-wrapper/LevelDBForSwift/LevelDBForSwift/LevelDBForSwift.h", "level-db-wrapper/LevelDBForSwift/LevelDBForSwift/src/Wrapper.hpp"
  s.vendored_libraries = "level-db-wrapper/LevelDBForSwift/leveldb/*.a"
  
  # s.resource_bundles = {
  #   'level-db-wrapper' => ['level-db-wrapper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'leveldb-library'
end
