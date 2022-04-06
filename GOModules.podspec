Pod::Spec.new do |spec|
 
  spec.name             = "GOModules"
  spec.version          = "0.0.1"
  spec.summary          = "A short description of GOModules." 
  spec.homepage         = "https://github.com/gaookey/GOModules"
  spec.license          = "MIT"
  spec.author           = { "高文立" => "gaookey@qq.com" } 
  spec.platform         = :ios, "10.0" 
  spec.source           = { :git => "https://github.com/gaookey/GOModules.git", :tag => "#{spec.version}" }
  #spec.source_files    = "Classes", "Classes/**/*" 
  #spec.resources       = "Resources/*.png"
  spec.swift_version    = "5.0"



  spec.subspec 'GOAnimationView' do |s|
     s.source_files = "Classes/GOAnimationView/**/*"
     s.dependency "SnapKit"
     s.dependency "lottie-ios"
  end

  spec.subspec 'GOEmptyDataView' do |s|
     s.source_files = "Classes/GOEmptyDataView/**/*"
     s.dependency "SnapKit"
  end

  spec.subspec 'GOHorizontalColorsView' do |s|
     s.source_files = "Classes/GOHorizontalColorsView/**/*"
     s.dependency "SnapKit"
     s.dependency "SDWebImage"
     s.dependency "SDWebImageWebPCoder"
     s.dependency "YYCategories"
  end

  spec.subspec 'GOImageListView' do |s|
     s.source_files = "Classes/GOImageListView/**/*"
     s.dependency "SnapKit"
     s.dependency "SDWebImage"
     s.dependency "SDWebImageWebPCoder"
  end

  spec.subspec 'GOImagesCarouselView' do |s|
     s.source_files = "Classes/GOImagesCarouselView/**/*"
     s.dependency "SnapKit"
     s.dependency "SDWebImage"
     s.dependency "SDWebImageWebPCoder"
     s.dependency "iCarousel"
  end

  spec.subspec 'GOPagingEnableLayout' do |s|
     s.source_files = "Classes/GOPagingEnableLayout/**/*"
     s.dependency "Masonry"
     s.dependency "SDWebImage"
     s.dependency "SDWebImageWebPCoder"
  end

  spec.subspec 'GOSafeAreaInsets' do |s|
     s.source_files = "Classes/GOSafeAreaInsets/**/*"
  end

  spec.subspec 'GOStarView' do |s|
     s.source_files = "Classes/GOStarView/**/*"
     s.resources    = "Resources/GOStarView/**/*.png"
     s.dependency "SnapKit"
  end

  spec.subspec 'GOWaterflowLayout' do |s|
     s.source_files = "Classes/GOWaterflowLayout/**/*"
  end

  spec.subspec 'GOAlertViewController' do |s|
     s.source_files = "Classes/GOAlertViewController/**/*"
     s.dependency "SnapKit"
  end

  spec.subspec 'GOCustomTagsView' do |s|
     s.source_files = "Classes/GOCustomTagsView/**/*"
     s.dependency "SnapKit"
     s.dependency "YYCategories"
  end

  spec.subspec 'GOCategoryNavigationView' do |s|
     s.source_files = "Classes/GOCategoryNavigationView/**/*"
     s.dependency "SnapKit"
     s.dependency "SDWebImage"
     s.dependency "SDWebImageWebPCoder"
  end  

  spec.subspec 'GOPageControl' do |s|
     s.source_files = "Classes/GOPageControl/**/*"
     s.dependency "SnapKit"
     s.dependency "YYCategories"
  end  

  spec.subspec 'GOSuccessAlertView' do |s|
     s.source_files = "Classes/GOSuccessAlertView/**/*"
     s.dependency "SnapKit"
  end 


end