
Pod::Spec.new do |spec|

  spec.name         = "LinkIDSDK"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of LinkIDSDK."
  spec.description  = "A complete description of LinkIDSDK."
  # spec.platform     = :ios
  spec.platform     = :ios, "13.0"

  spec.homepage     = "https://github.com/hathanhds/linkid_ios_sdk"
  spec.license      = "MIT"
  spec.author             = { "ThanhNTH" => "thanhnh.hpvn@gmail.com" }
  spec.source       = { :git => "https://github.com/hathanhds/linkid_ios_sdk.git", :tag => "0.0.1" }
  spec.swift_version = "5.0" 
  spec.source_files  = 'LinkIDSDK'
  spec.exclude_files = "Classes/Exclude"
end
