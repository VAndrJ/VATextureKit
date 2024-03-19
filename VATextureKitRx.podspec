Pod::Spec.new do |s|
  s.name             = 'VATextureKitRx'
  s.version          = '1.8.0'
  s.summary          = 'Texture library wrapper with Rx additions.'

  s.description      = <<-DESC
This library is designed to make it easier to work with Texture.
It provides an easier syntax and includes modern features to make developing faster.
Includes RxSwift additions.
                       DESC

  s.homepage         = 'https://github.com/VAndrJ/VATextureKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Volodymyr Andriienko' => 'vandrjios@gmail.com' }
  s.source           = { :git => 'https://github.com/VAndrJ/VATextureKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'VATextureKit/ClassesRx/**/*'

  s.dependency 'Texture',           '~> 3.1.0'
  s.dependency 'RxSwift',           '~> 6.5.0'
  s.dependency 'RxCocoa',           '~> 6.5.0'
  s.dependency 'Differentiator',    '~> 5.0.0'
  s.dependency 'VATextureKitSpec',  '1.8.0'
  s.dependency 'VATextureKit',      '1.8.0'

  s.swift_versions = '5.8'
end
