Pod::Spec.new do |spec|
  spec.name         = 'BarCodeKit'
  spec.version      = '1.3.1'
  spec.platform = :ios
  spec.platform = :osx
  spec.license      = 'BSD'
  spec.source       = { :git => 'https://github.com/Cocoanetics/BarCodeKit.git', :tag => spec.version.to_s }
  spec.source_files = 'Core/Source/*.{h,m}', 'Core/*.h'
  spec.ios.source_files = 'Core/Source/iOS/*.{h,m}' 
  spec.osx.source_files = 'Core/Source/Mac/*.{h,m}'
  spec.requires_arc = true
  spec.homepage     = 'http://www.cocoanetics.com/parts/barcodekit/'
  spec.summary      = 'A framework to generate bar codes on iOS or Mac.'
  spec.author       = { 'Oliver Drobnik' => 'oliver@cocoanetics.com' }
  spec.ios.frameworks = 'Foundation', 'UIKit'
  spec.osx.frameworks = 'Foundation', 'AppKit'
end
