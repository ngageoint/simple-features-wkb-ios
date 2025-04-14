Pod::Spec.new do |s|
  s.name             = 'sf-wkb-ios'
  s.version          = '5.0.0'
  s.license          =  {:type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'iOS SDK for Simple Features Well-Known Binary'
  s.homepage         = 'https://github.com/ngageoint/simple-features-wkb-ios'
  s.authors          = { 'NGA' => '', 'BIT Systems' => '', 'Brian Osborn' => 'bosborn@caci.com' }
  s.social_media_url = 'https://twitter.com/NGA_GEOINT'
  s.source           = { :git => 'https://github.com/ngageoint/simple-features-wkb-ios.git', :tag => s.version }
  s.requires_arc     = true
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.platform         = :ios, '12.0'
  s.ios.deployment_target = '12.0'

  s.source_files = 'sf-wkb-ios/**/*.{m}'
  s.public_header_files = 'sf-wkb-ios/**/*.h'

  s.frameworks = 'Foundation'

  s.dependency 'sf-ios', '5.0.0'
end
