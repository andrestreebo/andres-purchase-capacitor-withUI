Pod::Spec.new do |s|
  s.name = 'RevenuecatPurchasesUiCapacitor'
  s.version = '0.1.0'
  s.summary = 'RevenueCat Purchase UI SDK for Capacitor'
  s.license = 'MIT'
  s.homepage = 'https://github.com/andrestreebo/andres-purchase-capacitor-withUI'
  s.author = 'RevenueCat'
  s.source = { :git => 'https://github.com/andrestreebo/andres-purchase-capacitor-withUI.git', :tag => s.version.to_s }
  s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.ios.deployment_target = '13.0'
  s.dependency 'Capacitor'
  s.dependency 'RevenueCat'
  s.dependency 'RevenueCatUI'
  s.swift_version = '5.1'
end 