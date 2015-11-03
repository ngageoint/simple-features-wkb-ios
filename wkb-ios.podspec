Pod::Spec.new do |s|
  s.name             = 'wkb-ios'
  s.version          = '1.0.0'
  s.license          = 'MIT'
  s.summary          = 'iOS SDK for Well-Known Binary'
  s.homepage         = 'https://github.com/ngageoint/geopackage-wkb-ios'
  s.authors          = { 'Brian Osborn' => 'osbornb@bit-sys.com' }
  s.source           = { :git => 'https://github.com/ngageoint/geopackage-wkb-ios.git', :tag => s.version }
  s.requires_arc     = true
  
  s.platform         = :ios, '8.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'wkb-ios/**/*.{h,m}'
  s.prefix_header_file = 'wkb-ios/wkb-ios-Prefix.pch'
  s.public_header_files = 'wkb-ios/wkb_ios.h'

  s.resource_bundle = { 'WKB' => ['wkb-ios/**/*.plist'] }
  s.frameworks = 'Foundation'
end
