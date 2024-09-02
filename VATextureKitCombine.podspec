Pod::Spec.new do |s|
  s.name             = 'VATextureKitCombine'
  s.version          = '2.2.0'
  s.summary          = 'Texture library wrapper with Combine additions.'

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

  s.source_files = 'VATextureKit/ClassesCombine/**/*'

  s.swift_versions = '5.10'
end
