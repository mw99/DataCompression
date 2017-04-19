Pod::Spec.new do |s|
  s.name         = "DataCompression"
  s.version      = "2.0.1"
  s.summary      = "Swift libcompression wrapper as an extension for the Data type (ZLIB, LZFSE, LZMA, LZ4, deflate, RFC-1950, RFC-1951)"
  s.authors      = "Markus Wanke"
  s.homepage     = "https://github.com/mw99/DataCompression"
  s.license      = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.source       = { :git => "https://github.com/mw99/DataCompression.git", :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Sources/*.swift'
  s.requires_arc = true
end
