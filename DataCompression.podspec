Pod::Spec.new do |s|
  s.name         = "DataCompression"
  s.version      = "1.0.0"
  s.summary      = "Easy to use extension for the `Data` type to compress and decompress with ZLIB, LZMA, LZFSE, LZ4."
  s.authors      = 'Markus Wanke'
  s.homepage     = "https://github.com/mw99/DataCompression"
  s.license      = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.source       = { :git => "https://github.com/mw99/DataCompression.git", :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.source_files = 'SwiftDataCompression.swift'
  s.requires_arc = true
end
