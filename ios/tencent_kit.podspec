#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'tencent_kit'
  s.version          = '1.0.3'
  s.summary          = 'A powerful Flutter plugin allowing developers to share with natvie android & iOS Tencent SDKs.'
  s.description      = <<-DESC
A powerful Flutter plugin allowing developers to share with natvie android & iOS Tencent SDKs.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.vendored_frameworks = 'Libraries/*.framework'
  s.frameworks = 'SystemConfiguration', 'WebKit'
  # s.libraries = 'stdc++'
  # s.requires_arc = true

  s.ios.deployment_target = '8.0'
end

