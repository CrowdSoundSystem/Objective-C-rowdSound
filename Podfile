source 'https://github.com/CocoaPods/Specs.git'

target 'CrowdSoundApp' do
  pod 'Protobuf', :path => "lib/grpc/third_party/protobuf"
  pod 'BoringSSL', :podspec => "lib/grpc/src/objective-c"
  pod 'gRPC', :path => "lib/grpc"
  
  # Depend on the generated CrowdSound library.
  pod 'CrowdSound', :path => '.'
  
  #Useful APIs
  pod 'Bolts'
  
  #UI Controls
  pod 'CSStickyHeaderFlowLayout'
  pod 'RESideMenu'
  pod 'HPLTagCloudGenerator'
end