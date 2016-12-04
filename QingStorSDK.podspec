Pod::Spec.new do |s|
  s.name = 'QingStorSDK'
  s.version = '2.0.0-beta.1'
  s.summary = 'The official QingStor SDK for the swift programming language.'
  s.authors = 'Chris Yang <chrisyang@yunify.com>'
  s.license = 'Apache License, Version 2.0'
  s.homepage = "https://www.qingstor.com"
  s.source = { :git => "https://github.com/yunify/qingstor-sdk-swift.git", :tag => s.version }
  s.platform = :ios, "9.0"
  s.source_files = 'Sources/**/*.swift'
  s.dependency 'Alamofire', '~> 4.0'
  s.dependency 'CryptoSwift', '~> 0.6.1'
  s.dependency 'ObjectMapper', '~> 2.2'
  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '3.0',
  }
end
