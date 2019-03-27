Pod::Spec.new do |s|
  s.name         = "DataCompression"
  s.version      = "3.4.0"
  s.summary      = "Swift libcompression wrapper as an extension for the Data type (GZIP, ZLIB, LZFSE, LZMA, LZ4, deflate, RFC-1950, RFC-1951, RFC-1952)"
  s.authors      = { "Markus Wanke" => "mw99@users.noreply.github.com" }
  s.homepage     = "https://github.com/mw99/DataCompression"
  s.license      = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.source       = { :git => "https://github.com/mw99/DataCompression.git", :tag => s.version }

  s.swift_version = '5.0'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Sources/DataCompression/*.swift'
  s.requires_arc = true
end
