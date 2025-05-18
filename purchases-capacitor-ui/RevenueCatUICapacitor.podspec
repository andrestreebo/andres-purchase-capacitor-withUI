require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'RevenueCatUICapacitor'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = package['repository']['url']
  s.author = package['author']
  s.ios.deployment_target = '13.0'
  s.source = { :git => package['repository']['url'], :tag => s.version.to_s }
  s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.resource_bundles = {
    'CapacitorRevenueCatUI' => [
      'ios/Plugin/Assets/*.{png,storyboard,xib,xcassets}'
    ]
  }
  s.public_header_files = 'ios/Plugin/**/*.h'
  s.dependency 'Capacitor'
  s.dependency 'PurchasesHybridCommonUI', '~> 13.32'
  s.swift_version = '5.1'
end 