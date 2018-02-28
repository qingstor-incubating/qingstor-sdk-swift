Pod::Spec.new do |s|
  s.name = 'QingStorSDK'
  s.version = '2.5.0'
  s.summary = 'The official QingStor SDK for the swift programming language.'
  s.authors = 'Chris Yang <chrisyang@yunify.com>'
  s.license = 'Apache License, Version 2.0'
  s.homepage = "https://www.qingstor.com"
  s.source = { :git => "https://github.com/yunify/qingstor-sdk-swift.git", :tag => s.version }
  s.platform = :ios, "9.0"
  s.default_subspec = "Core"
  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '4.0',
  }

  s.subspec "Core" do |ss|
    ss.source_files  = "Sources/QingStor/"
    ss.dependency 'Alamofire', '~> 4.6'
    ss.dependency 'CryptoSwift', '~> 0.8.3'
    ss.dependency 'ObjectMapper', '~> 3.1'
  end

  s.subspec "ObjcBridge" do |ss|
    ss.source_files = "Sources/ObjcBridge/"
    ss.dependency "QingStorSDK/Core"
  end
  
end
