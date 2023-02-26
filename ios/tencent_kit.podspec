#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tencent_kit.podspec` to validate before publishing.
#

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

current_dir = Dir.pwd
calling_dir = File.dirname(__FILE__)
project_dir = calling_dir.slice(0..(calling_dir.index('/.symlinks')))
flutter_project_dir = calling_dir.slice(0..(calling_dir.index('/ios/.symlinks')))
cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'))
if cfg['tencent_kit'] && cfg['tencent_kit']['app_id']
    app_id = cfg['tencent_kit']['app_id']
    universal_link = cfg['tencent_kit']['universal_link']
    options = ""
    if universal_link
        options = "-u #{universal_link}"
    end
    system("ruby #{current_dir}/tencent_setup.rb -a #{app_id} #{options} -p #{project_dir} -n Runner.xcodeproj")
end

Pod::Spec.new do |s|
  s.name             = 'tencent_kit'
  s.version          = library_version
  s.summary          = pubspec['description']
  s.description      = pubspec['description']
  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # v3.5.11
  s.subspec 'vendor' do |sp|
    sp.vendored_frameworks = 'Libraries/*.framework'
    sp.frameworks = 'Security', 'SystemConfiguration', 'CoreGraphics', 'CoreTelephony', 'WebKit'
    sp.libraries = 'iconv', 'sqlite3', 'stdc++', 'z'
    sp.requires_arc = true
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
