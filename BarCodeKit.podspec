Pod::Spec.new do |spec|
  spec.name         = 'BarCodeKit'
  spec.version      = '1.2.0'
  spec.license      = 'BSD'
  spec.source       = { :git => 'git@git.cocoanetics.com:parts/barcodekit.git', :tag => spec.version.to_s }
  spec.ios.source_files = 'Core/Source/iOS/*.{h,m}', 'Core/Source/*.{h,m}', 'Core/*.h'
  spec.osx.source_files = 'Core/Source/Mac/*.{h,m}', 'Core/Source/*.{h,m}', 'Core/*.h'
  spec.requires_arc = true
  spec.homepage     = 'http://www.cocoanetics.com/parts/barcodekit/'
  spec.summary      = 'A framework to generate bar codes on iOS or Mac.'
  spec.author       = { 'Oliver Drobnik' => 'oliver@cocoanetics.com' }
  spec.ios.frameworks = 'Foundation', 'UIKit'
  spec.osx.frameworks = 'Foundation', 'AppKit'
end
