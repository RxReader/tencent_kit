#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tencent_kit.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tencent_kit'
  s.version          = '2.0.1'
  s.summary          = 'A powerful Flutter plugin allowing developers to auth/share with natvie Android & iOS Tencent SDKs.'
  s.description      = <<-DESC
A powerful Flutter plugin allowing developers to auth/share with natvie Android & iOS Tencent SDKs.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # v3.5.1
  s.subspec 'vendor' do |sp|
    sp.vendored_frameworks = 'Libraries/*.framework'
    sp.frameworks = 'Security', 'SystemConfiguration', 'CoreGraphics', 'CoreTelephony', 'WebKit'
    sp.libraries = 'iconv', 'sqlite3', 'stdc++', 'z'
    sp.requires_arc = true
  end
  
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
