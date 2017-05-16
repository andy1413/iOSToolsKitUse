#
# Be sure to run `pod lib lint iOSToolsKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iOSToolsKit'
  s.version          = '1.1'
  s.summary          = 'A short description of iOSToolsKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wangfangshuai/iOSToolsKitUse.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangfangshuai' => 'wangfangshuai@jd.com' }
  s.source           = { :git => 'https://github.com/wangfangshuai/iOSToolsKitUse.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'iOSToolsKit/Classes/**/*'
  s.exclude_files = 'iOSToolsKit/Classes/JSONKit.{h,m}'
s.requires_arc = true

  s.default_subspec = 'All'
  s.subspec 'All' do |spec|
  spec.ios.dependency 'iOSToolsKit/KeychainItemWrapper'
  spec.ios.dependency 'iOSToolsKit/RSAAndDESEncryption'
spec.ios.dependency 'iOSToolsKit/JSONKit'
  end

s.subspec 'KeychainItemWrapper' do |ss|
ss.requires_arc = true
ss.public_header_files = 'iOSToolsKit/Classes/KeychainItemWrapper.h'
ss.source_files = [
'iOSToolsKit/Classes/KeychainItemWrapper.{h,m}'
]
end

  s.subspec 'RSAAndDESEncryption' do |ss|
    ss.requires_arc = true
    ss.public_header_files = 'iOSToolsKit/Classes/RSAAndDESEncryption/iOSRSAAndDesEncryption.h'
    ss.source_files = [
    'iOSToolsKit/Classes/RSAAndDESEncryption/*'
    ]
    ss.dependency 'iOSToolsKit/KeychainItemWrapper'
  end

  s.subspec 'JSONKit' do |ss|
    ss.requires_arc = false
    ss.public_header_files = 'iOSToolsKit/Classes/JSONKit.h'
    ss.source_files = [
      'iOSToolsKit/Classes/JSONKit.{h,m}'
    ]
    ss.compiler_flags = '-fno-objc-arc'
  end
  
  # s.resource_bundles = {
  #   'iOSToolsKit' => ['iOSToolsKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
#s.dependency 'JSONKit'
s.dependency 'MD5Digest'
s.dependency 'OpenSSL'
s.dependency 'GTMBase64'
end
