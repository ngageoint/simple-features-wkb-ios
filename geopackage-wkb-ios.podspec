Pod::Spec.new do |s|
  s.name             = "geopackage-wkb-ios"
  s.version          = "1.0.0"
  s.summary          = "GeoPackage iOS SDK for Well-Known Binary"
  s.description      = <<-DESC
                       iOS SDK for Well-Known Binary
                       DESC
  s.homepage         = "https://www.nga.mil"
  s.license          = 'DOD'
  s.author           = { "NGA" => "osbornb@bit-sys.com" }
  s.source           = { :git => "https://git.geointapps.org/geopackage/wkb-ios.git", :tag => s.version.to_s }

  s.platform         = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'wkb-ios/**/*.{h,m}'
  s.prefix_header_file = 'wkb-ios/wkb-ios-Prefix.pch'

  #s.ios.exclude_files = 'Classes/osx'
  #s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.resource_bundle = { 'WKB' => ['wkb-ios/**/*.plist'] }
  s.resources = ['wkb-ios/**/*.xcdatamodeld']
  s.frameworks = 'Foundation'
end
