
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
  s.dependency 'SVProgressHUD'
  s.dependency 'RxCocoa'
  s.dependency 'Moya/RxSwift'
  s.dependency 'SDWebImage', '~> 5.18.10'
  s.dependency 'iCarousel', '~> 1.8.3'
  s.dependency 'SkeletonView'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency 'SwiftyAttributes'
  s.dependency 'Tabman', '~> 3.0'
  s.dependency 'EasyTipView'
  #s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  
  # 8
  s.source_files = "LinkIDSDK/**/*.{swift}"
  
  # 9
  s.resources = "LinkIDSDK/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,ttf}"
  
  # 10
  s.swift_version = "4.2"
  
  end
