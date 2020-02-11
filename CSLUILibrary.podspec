Pod::Spec.new do |s|
  s.name         = 'CSLUILibrary'
  s.version      = '0.1.9'
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
  s.subspec 'SLAlertView' do |alert|
    alert.source_files = 'CSLUILibrary/SLAlertView/*.{h,m}'
    alert.source_files = 'CSLUILibrary/SLLable/*.{h,m}'
    alert.source_files = 'CSLUILibrary/SLImageView/*.{h,m}'
  end
end
