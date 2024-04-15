Pod::Spec.new do |s|
  s.name             = 'VATextureKitSpec'
  s.version          = '1.9.0'
  s.summary          = 'Texture library Layout Specs wrapper.'

  s.description      = <<-DESC
This library is designed to make it easier to work with Texture.
It provides an easier syntax and includes wrappers on top of Layout Specs.
                       DESC

  s.homepage         = 'https://github.com/VAndrJ/VATextureKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Volodymyr Andriienko' => 'vandrjios@gmail.com' }
  s.source           = { :git => 'https://github.com/VAndrJ/VATextureKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'

  s.source_files = 'VATextureKit/ClassesSpec/**/*'

  s.dependency 'Texture',           '~> 3.1.0'

  s.swift_versions = '5.8'
end
