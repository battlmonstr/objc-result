Pod::Spec.new do |spec|
  spec.name = "OCResult"
  spec.version = "0.1.0"
  spec.summary = "Objective-C 'Result' type port from Swift."
  spec.homepage = "https://github.com/battlmonstr/objc-result"
  spec.license = { :type => "MIT", :file => "LICENSE.txt" }
  spec.author = "battlmonstr"
  spec.social_media_url = "https://twitter.com/battlmonstr"
  spec.source = { :git => "https://github.com/battlmonstr/objc-result.git", :tag => "#{spec.version}" }

  spec.default_subspec = "ObjC"
  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.7"
  spec.swift_versions = ['4.0', '4.2', '5.0']

  spec.subspec "ObjC" do |subspec|
    subspec.source_files = "OCResult/*.{h,m}"
    subspec.exclude_files = "OCResult/OCResult-Bridging-Header.h"
    subspec.requires_arc = true
  end

  spec.subspec "Swift" do |subspec|
    subspec.dependency "OCResult/ObjC"
    subspec.source_files = "OCResult/*.swift"
    subspec.ios.deployment_target = "9.0"
    subspec.osx.deployment_target = "10.9"
  end
end
