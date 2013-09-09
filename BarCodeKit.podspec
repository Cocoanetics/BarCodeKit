Pod::Spec.new do |spec|
  spec.name         = 'BarCodeKit'
  spec.version      = '1.1.0'
  spec.platform     = :ios, '7.0'
  spec.license      = 'BSD'
  spec.source       = { :git => 'git@git.cocoanetics.com:parts/barcodekit.git', :tag => spec.version.to_s }
  spec.source_files = 'Core/Source/*.{h,m}', 'Core/*.h'
  spec.requires_arc = true
  spec.homepage     = 'http://www.cocoanetics.com/parts/barcodekit/'
  spec.summary      = 'A framework to generate bar codes on iOS.'
  spec.author       = { 'Oliver Drobnik' => 'oliver@cocoanetics.com' }
end
