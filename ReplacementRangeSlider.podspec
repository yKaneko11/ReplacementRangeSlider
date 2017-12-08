#
# Be sure to run `pod lib lint ReplacementRangeSlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ReplacementRangeSlider'
  s.version          = '0.1.3'
  s.summary          = 'Useful extensions for UISlider.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Useful extensions for UISlider.
UISlider are extended.
                       DESC

  s.homepage         = 'https://github.com/yKaneko11/ReplacementRangeSlider'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yKaneko11' => 'nj0hzvkj@gmail.com' }
  s.source           = { :git => 'https://github.com/yKaneko11/ReplacementRangeSlider.git', :tag => s.version.to_s }
  # s.social_media_url = ''

  s.ios.deployment_target = '8.0'

  s.source_files = 'ReplacementRangeSlider/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ReplacementRangeSlider' => ['ReplacementRangeSlider/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
