#
#  Be sure to run `pod spec lint LinkIDSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "LinkIDSDK"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of LinkIDSDK."
  spec.description  = "A complete description of LinkIDSDK."
  spec.platform     = :ios, "13.0"

  spec.homepage     = "http://EXAMPLE/LinkIDSDK"
  spec.license      = "MIT"
  spec.author             = { "ThanhNTH" => "thanhnh.hpvn@gmail.com" }
  spec.source       = { :git => "http://EXAMPLE/LinkIDSDK.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"
end
