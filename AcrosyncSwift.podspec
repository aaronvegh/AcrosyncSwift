#
#  Be sure to run `pod spec lint AcrosyncSwift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "AcrosyncSwift"
  spec.version      = "0.0.2"
  spec.summary      = "A Swift framework for the Acrosync library"
  spec.description  = "This is an iOS framework for using the Acrosync Library, an implementation of the Rsync protocol available with a mixed RPL/commercial license."
  spec.homepage     = "https://github.com/aaronvegh/AcrosyncSwift"
  spec.license      = "Unlicense"
  spec.author             = { "Aaron Vegh" => "aaron@innoveghtive.com" }
  spec.social_media_url   = "https://twitter.com/aaronvegh"
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/aaronvegh/AcrosyncSwift.git", :tag => "#{spec.version}" }
  spec.source_files  = "AcrosyncSwift", "AcrosyncSwift/**/*.{h,m}"
  spec.exclude_files = "AcrosyncSwiftExample"
end
