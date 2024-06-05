Pod::Spec.new do |s|
  s.name             = 'VATextureKitRx'
  s.version          = '2.0.2'
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

  s.ios.deployment_target = '14.0'

  s.source_files = 'VATextureKit/ClassesRx/**/*'

  s.dependency 'Texture',           '~> 3.2.0'
  s.dependency 'RxSwift',           '~> 6.5.0'
  s.dependency 'RxCocoa',           '~> 6.5.0'
  s.dependency 'Differentiator',    '~> 5.0.0'
  s.dependency 'VATextureKitSpec',  '2.0.2'
  s.dependency 'VATextureKit',      '2.0.2'

  s.swift_versions = '5.9'
end
