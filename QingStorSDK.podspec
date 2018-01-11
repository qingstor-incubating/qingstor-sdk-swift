Pod::Spec.new do |s|
  s.name = 'QingStorSDK'
  s.version = '2.5.0'
  s.summary = 'The official QingStor SDK for the swift programming language.'
  s.authors = 'Chris Yang <chrisyang@yunify.com>'
  s.license = 'Apache License, Version 2.0'
  s.homepage = "https://www.qingstor.com"
  s.source = { :git => "https://github.com/yunify/qingstor-sdk-swift.git", :tag => s.version }
  s.platform = :ios, "9.0"
  s.source_files = 'Sources/**/*.swift'
  s.dependency 'Alamofire', '~> 4.5'
  s.dependency 'CryptoSwift', '~> 0.7.2'
  s.dependency 'ObjectMapper', '~> 3.1'
  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '4.0',
  }
end
