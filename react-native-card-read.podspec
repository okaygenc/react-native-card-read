require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-card-read"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "13.0" }
  s.source       = { :git => "https://github.com/okaygenc/react-native-card-read.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"

  # Enable module map for Swift-ObjC interop without bridging header
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }

  s.dependency "React-Core"

  # Dependencies from forked card-reader (specify source in Podfile)
  s.dependency "StripeCore"
  s.dependency "StripeCameraCore"
  s.dependency "StripeCardScan"

  # Required iOS frameworks
  s.frameworks = 'AVFoundation', 'AVKit', 'CoreML', 'VideoToolbox', 'Vision', 'UIKit'

  s.swift_version = '5.0'
end
