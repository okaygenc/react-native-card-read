# This is an example of how to configure your test app's Podfile
# Copy the relevant sections to your test app's ios/Podfile

require_relative '../node_modules/react-native/scripts/react_native_pods'
require_relative '../node_modules/@react-native-community/cli-platform-ios/native_modules'

platform :ios, '13.0'

target 'YourAppName' do
  config = use_native_modules!

  use_react_native!(
    :path => config[:reactNativePath],
    :hermes_enabled => true,
    :fabric_enabled => false,
  )

  # ========================================
  # Local card-reader dependencies
  # ========================================
  # Path to the local card-reader fork (adjust based on your directory structure)
  card_reader_path = File.expand_path('../../card-reader', __dir__)

  # Add local pod dependencies from card-reader
  pod 'StripeCore', :path => card_reader_path
  pod 'StripeCameraCore', :path => card_reader_path
  pod 'StripeCardScan', :path => card_reader_path

  # Your react-native-card-read library
  # If installed via npm, this will be auto-linked
  # If you need to specify manually:
  # pod 'react-native-card-read', :path => '../node_modules/react-native-card-read'
  # ========================================

  post_install do |installer|
    react_native_post_install(installer)

    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
