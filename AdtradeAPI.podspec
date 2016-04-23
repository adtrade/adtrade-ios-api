Pod::Spec.new do |s|
  s.name         = "AdtradeAPI"

  s.version      = "1.0.0"

  s.summary      = "Wrapper for Adtrade API. "

  s.homepage     = "https://github.com/adtrade/AdtradeAPI"

	s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }

  s.author       = { "williamlocke" => "williamlocke@me.com" }

  s.source       = { :git => "https://github.com/adtrade/adtrade-ios-api.git", :tag => s.version.to_s }

  s.dependency 'ATNetworking'

  s.platform     = :ios, '6.0'
  
  s.source_files =  'Classes/**/*.[h,m]'
  
  s.frameworks = 'AdSupport'
  
  s.requires_arc = true

end
