Pod::Spec.new do |s|
  s.name         = 'CSLUILibrary'
  s.version      = '0.0.1'
  s.summary      = 'UI configurable interface Library'
  s.homepage     = 'https://github.com/chengshiliang/CSLUILibrary'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'chengshiliang' => '285928582@qq.com' }
  s.source       = { :git => 'https://github.com/chengshiliang/CSLUILibrary.git', :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.source_files = 'CSLUILibrary/*.{h,m}'
  s.requires_arc = true
  s.frameworks   = 'Foundation', 'UIKit'
  s.dependency 'CSLCommonLibrary'
  s.dependency 'Masonry'
  s.subspec 'Config' do |s1|
    s1.source_files = 'CSLUILibrary/Config/*.{h,m}'
    end
  s.subspec 'Const' do |s2|
    s2.source_files = 'CSLUILibrary/Const/*.{h,m}'
    end
  s.subspec 'Utils' do |s3|
    s3.source_files = 'CSLUILibrary/Utils/*.{h,m}'
    end
  s.subspec 'SLLabel' do |s4|
    s4.source_files = 'CSLUILibrary/SLLabel/*.{h,m}'
    end
end
