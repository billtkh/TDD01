# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TDD01' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TDD01
  pod 'RxSwift', '6.2.0'
  pod 'RxCocoa', '6.2.0'
  pod 'SnapKit', '~> 5.0.0'
  
  pod 'ReactiveObjC'
  pod 'Masonry'

  target 'TDD01Tests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxSwift', '6.2.0'
    pod 'RxCocoa', '6.2.0'
  end

end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
    end
end
