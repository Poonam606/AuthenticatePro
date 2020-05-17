# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'AuthenticatePro' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AuthenticatePro
  pod 'NVActivityIndicatorView'
  pod 'SideMenu'
  pod 'Bolts'
  pod 'FBSDKLoginKit'
  pod 'FBSDKCoreKit'
  pod 'DTPhotoViewerController'
  pod 'LinkedinSwift'
  pod 'SwiftyJSON'
  pod 'SDWebImage'
  pod 'PopupDialog'
  pod 'GoogleSignIn'
  pod 'IQKeyboardManagerSwift'
 
  target 'AuthenticateProTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AuthenticateProUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
