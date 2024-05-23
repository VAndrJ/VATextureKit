Pod::Spec.new do |s|
  s.name             = 'VATextureKit'
  s.version          = '2.0.0'
  s.summary          = 'Texture library wrapper.'

  s.description      = <<-DESC
This library is designed to make it easier to work with Texture.
It provides an easier syntax and includes modern features to make developing faster.
                       DESC

  s.homepage         = 'https://github.com/VAndrJ/VATextureKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Volodymyr Andriienko' => 'vandrjios@gmail.com' }
  s.source           = { :git => 'https://github.com/VAndrJ/VATextureKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '14.0'

  s.source_files = 'VATextureKit/Classes/**/*'
  s.resource_bundles = {
    'VATextureKitPrivacyInfo' => ['VATextureKit/Classes/PrivacyInfo.xcprivacy']
  }

  s.dependency 'Texture',           '~> 3.2.0'
  s.dependency 'VATextureKitSpec',  '2.0.0'

  s.swift_versions = '5.9'
end
