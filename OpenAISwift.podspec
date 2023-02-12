Pod::Spec.new do |s|
  s.name = 'OpenAISwift'
  s.version = '0.0.1'
  s.summary = 'OpenAISwift'
  s.description  = <<-DESC
  commit:${commit}
  DESC
  s.license = 'MIT'
  s.homepage = 'https://github.com/KittenYang/OpenAISwift'
  s.source = { :git => 'https://github.com/KittenYang/OpenAISwift.git', :tag => "#{s.version}" }
  s.authors = { 'KittenYang' => 'imkittenyang@gmail.com' }
  s.source_files = 'Sources/**/*.{h,m,swift}'
  s.exclude_files = ['Resources/OpenAISwift.bundle/Info.plist']
	
	s.ios.deployment_target = '14.0'
	s.osx.deployment_target = '12.0'
	s.tvos.deployment_target = '10.0'
	s.watchos.deployment_target = '3.0'
	

end
