#
#  Be sure to run `pod spec lint SwiftyInAppMessaging.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "SwiftyInAppMessaging"
  spec.version      = "0.3.0"
  spec.summary      = "The easiest way to coexist your customized view and InAppMessaging default view."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
  The easiest way to coexist your customized view and InAppMessaging default view.
                   DESC

  spec.homepage     = "https://github.com/fumito-ito/SwiftyInAppMessaging"
  spec.license      = { :type => "Apache2", :file => "LICENSE" }
  spec.author             = { "Fumito Ito" => "weathercook@gmail.com" }
  spec.social_media_url   = "https://twitter.com/fumito_ito"

  spec.ios.deployment_target    = "12.0"
  spec.tvos.deployment_target   = "12.0"

  spec.source       = { :git => "https://github.com/fumito-ito/SwiftyInAppMessaging.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources", "Sources/**/*.{h,m,swift}"

  # spec.requires_arc = true

  spec.static_framework = true
  spec.swift_version = '5.3'
  spec.dependency "Firebase/InAppMessaging", "8.11.0"

end
