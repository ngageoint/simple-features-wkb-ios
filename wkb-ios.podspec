Pod::Spec.new do |s|
  s.name             = 'wkb-ios'
  s.version          = '1.0.1'
  s.license          =  {:type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'iOS SDK for Well-Known Binary'
  s.homepage         = 'https://github.com/ngageoint/geopackage-wkb-ios'
  s.authors          = { 'NGA' => '', 'Brian Osborn' => 'osbornb@bit-sys.com' }
  s.social_media_url = 'https://twitter.com/NGA_GEOINT'
  s.source           = { :git => 'https://github.com/ngageoint/geopackage-wkb-ios.git', :tag => s.version }
  s.requires_arc     = true
  
  s.platform         = :ios, '8.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'wkb-ios/**/*.{h,m}'

  s.resource_bundle = { 'WKB' => ['wkb-ios/**/*.plist'] }
  s.frameworks = 'Foundation'
end
