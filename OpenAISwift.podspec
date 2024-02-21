Pod::Spec.new do |s|
  s.name = 'OpenAISwift'
  s.version = '1.3.0'
  s.license = 'MIT'
  s.summary = 'This is a wrapper library around the ChatGPT and OpenAI HTTP API'
  s.homepage = 'https://github.com/izyumkin/OpenAISwift'
  s.authors = { 'Adam Rush' => 'http://swiftlyrush.com' }
  
  s.source = { :git => 'https://github.com/izyumkin/OpenAISwift.git', :tag => s.version.to_s }
  s.source_files = 'Sources/**/*.swift'
  s.swift_version = '4.2'
  s.platform = :ios, '11.1'
end