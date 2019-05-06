Pod::Spec.new do |spec|

  spec.name         = "GWLTestCode"
  spec.version      = "0.0.1"
  spec.summary      = "一个简单的介绍."
  spec.homepage     = "https://github.com/gwlCode/GWLPodTest"
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author             = { "gwl" => "153018865@qq.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/gwlCode/GWLPodTest.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "GWLPodTest/GWLPodTest/Classes/**/*.{h,m}"
  spec.requires_arc = true

end
