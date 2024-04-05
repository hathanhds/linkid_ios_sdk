
Pod::Spec.new do |s|

  # 1
  s.platform = :ios
  s.ios.deployment_target = '12.0'
  s.name = "LinkIDSDK"
  s.summary = "LinkIDSDK lets a user exchange vocuher"
  s.requires_arc = true
  
  # 2
  s.version = "0.0.1"
  
  # 3
  s.license = { :type => "MIT", :file => "LICENSE" }
  
  # 4
  s.author = { "ThanhNTH" => "thanhnh.hpvn@gmail.com" }
  
  # 5 
  s.homepage = "https://github.com/hathanhds/linkid_ios_sdk"
  
  # 6
  s.source = { :git => "https://github.com/hathanhds/linkid_ios_sdk.git", 
               :tag => "#{s.version}" }
  
  # 7
  s.framework = "UIKit"
  s.dependency 'Alamofire', '~> 4.7'
  s.dependency 'SVProgressHUD', '~> 2.2.5'
  
  # 8
  s.source_files = "LinkIDSDK/**/*.{swift}"
  
  # 9
  s.resources = "LinkIDSDK/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
  
  # 10
  s.swift_version = "4.2"
  
  end
