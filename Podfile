# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def ui_pods
  pod 'Charts', '= 4.1.0'
  pod 'SnapKit', '= 5.6.0'
  pod 'PKHUD', '= 5.3.0'
end

def network_pods
  pod 'Alamofire', '= 5.4.4'
end

def reactive_pods
  pod 'RxSwift', '= 6.2.0'
  pod 'RxCocoa', '= 6.2.0'
  pod 'RxOptional', '= 5.0.2'
end

target 'crypto_app' do
  
  use_frameworks!
  inhibit_all_warnings!
  
  ui_pods
  network_pods
  reactive_pods
  
end
