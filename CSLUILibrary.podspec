Pod::Spec.new do |s|
  s.name         = 'CSLUILibrary'
  s.version      = '0.1.11'
  s.summary      = 'UI configurable interface Library'
  s.homepage     = 'https://github.com/chengshiliang/CSLUILibrary'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'chengshiliang' => '285928582@qq.com' }
  s.source       = { :git => 'https://github.com/chengshiliang/CSLUILibrary.git', :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.source_files = 'CSLUILibrary/*.{h,m}'
  s.source_files = 'CSLUILibrary/**/*.{h,m}'
  s.source_files = 'CSLUILibrary/**/**/*.{h,m}'
  s.requires_arc = true
  s.frameworks   = 'Foundation', 'UIKit'
  s.resources    = 'CSLUILibrary/Resources/*.png'
  s.dependency 'CSLCommonLibrary'
  s.dependency 'JSONModel'
  s.subspec 'SLImageView' do |imageView|
    imageView.source_files = 'CSLUILibrary/SLImageView/*.{h,m}'
    imageView.frameworks = 'Accelerate'
  end
  s.subspec 'SLLabel' do |label|
    label.source_files = 'CSLUILibrary/SLLabel/*.{h,m}'
    label.frameworks   = 'CoreText', 'CoreFoundation'
    label.dependency 'CSLUILibrary/SLImageView'
  end
  s.subspec 'SLView' do |view|
    view.source_files = 'CSLUILibrary/SLView/*.{h,m}'
  end
  s.subspec 'SLButton' do |button|
    button.source_files = 'CSLUILibrary/SLButton/*.{h,m}'
  end
  s.subspec 'SLNavigationController' do |navigation|
    navigation.source_files = 'CSLUILibrary/SLNavigationController/*.{h,m}'
  end
  s.subspec 'SLTabbarView' do |tabbarView|
    tabbarView.source_files = 'CSLUILibrary/SLTabbarView/*.{h,m}'
    tabbarView.dependency 'CSLUILibrary/SLButton'
    tabbarView.dependency 'CSLUILibrary/SLView'
  end
  s.subspec 'SLTabbarController' do |tabbarController|
    tabbarController.source_files = 'CSLUILibrary/SLTabbarController/*.{h,m}'
    tabbarController.dependency 'CSLUILibrary/SLNavigationController'
    tabbarController.dependency 'CSLUILibrary/SLTabbarView'
  end
  s.subspec 'SLAlertView' do |alert|
    alert.source_files = 'CSLUILibrary/SLAlertView/*.{h,m}'
    alert.dependency 'CSLUILibrary/SLView'
    alert.dependency 'CSLUILibrary/SLImageView'
    alert.dependency 'CSLUILibrary/SLLabel'
    alert.dependency 'CSLUILibrary/SLTabbarView'
  end
end
