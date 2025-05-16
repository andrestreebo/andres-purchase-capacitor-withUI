require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'AsbPurchasesUiCapacitor'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = package['repository']['url']
  s.author = package['author']
  s.source = { :git => package['repository']['url'], :tag => s.version.to_s }
  s.source_files = 'ios/Sources/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.ios.deployment_target = '15.0'
  s.framework = 'UIKit'
  s.dependency 'Capacitor'
  s.dependency 'RevenueCat', '~> 5.21.0'
  s.dependency 'RevenueCatUI', '~> 5.21.0'
  s.static_framework = true
  s.swift_version = '5.1'
end
