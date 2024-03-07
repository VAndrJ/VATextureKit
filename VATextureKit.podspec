Pod::Spec.new do |s|
  s.name             = 'VATextureKit'
  s.version          = '1.3.0'
  s.summary          = 'Texture library wrapper.'

  s.description      = <<-DESC
This library is designed to make it easier to work with Texture.
It provides an easier syntax and includes modern features to make developing faster.
                       DESC

  s.homepage         = 'https://github.com/VAndrJ/VATextureKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Volodymyr Andriienko' => 'vandrjios@gmail.com' }
  s.source           = { :git => 'https://github.com/VAndrJ/VATextureKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'VATextureKit/Classes/**/*'
  
  s.dependency 'Texture',           '~> 3.1.0'
  s.dependency 'VATextureKitSpec',  '1.3.0'

  s.swift_versions = '5.9'
end
