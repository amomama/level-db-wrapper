#
# Be sure to run `pod lib lint level-db-wrapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'level-db-wrapper'
  s.version          = '1.0.9'
  s.summary          = 'Wrapper is used to get/set key-value data from leveldb storage.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    Level DB storage is used as a pod instead of local library. Also bulk key fetch is available. 
                       DESC

  s.homepage         = 'https://github.com/amomama/level-db-wrapper.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ivan-genesis' => 'ivan.sinitsa@gen.tech' }
  s.source           = { :git => 'https://github.com/amomama/level-db-wrapper.git', :tag => s.version.to_s }


  s.ios.deployment_target = '10.3'
  s.platform     = :ios, "10.3"

  s.source_files  = "Classes", "level-db-wrapper/LevelDBForSwift/**/*.{swift,hpp,cpp,h,m}"
  s.public_header_files = "level-db-wrapper/LevelDBForSwift/LevelDBForSwift/LevelDBForSwift.h", "level-db-wrapper/LevelDBForSwift/LevelDBForSwift/src/Wrapper.hpp"
  
  s.dependency 'leveldb-library'
end
