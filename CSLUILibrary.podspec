Pod::Spec.new do |s|
  s.name         = 'CSLUILibrary'
  s.version      = '0.2.5'
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
  s.dependency 'CSLCommonLibrary'
  # s.dependency 'JSONModel'
  s.subspec 'SLMVP' do |mvp|
    mvp.source_files = 'CSLUILibrary/SLMVP/*.{h,m}'
  end
  s.subspec 'SLModel' do |model|
    model.source_files = 'CSLUILibrary/SLModel/*.{h,m}'
  end
  s.subspec 'SLImageView' do |imageView|
    imageView.source_files = 'CSLUILibrary/SLImageView/*.{h,m}'
    imageView.frameworks = 'Accelerate'
  end
  s.subspec 'SLImage' do |image|
    image.source_files = 'CSLUILibrary/SLImage/*.{h,m}'
  end
  s.subspec 'SLImageDownloader' do |imageDown|
    imageDown.source_files = 'CSLUILibrary/SLImageDownloader/*.{h,m}'
    imageDown.dependency 'SDWebImage'
    imageDown.dependency 'CSLUILibrary/SLImageView'
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
  s.subspec 'SLNoticeBar' do |noticeBar|
    noticeBar.source_files = 'CSLUILibrary/SLNoticeBar/*.{h,m}'
    noticeBar.dependency 'CSLUILibrary/SLView'
    noticeBar.dependency 'CSLUILibrary/SLImageView'
  end
  s.subspec 'SLPopoverView' do |popoverView|
    popoverView.source_files = 'CSLUILibrary/SLPopoverView/*.{h,m}'
    popoverView.dependency 'CSLUILibrary/SLView'
    popoverView.dependency 'CSLUILibrary/SLTabbarView'
  end
  s.subspec 'SLScrollView' do |scrollView|
    scrollView.source_files = 'CSLUILibrary/SLScrollView/*.{h,m}'
    scrollView.dependency 'CSLUILibrary/SLView'
    scrollView.dependency 'CSLUILibrary/SLImageView'
  end
  s.subspec 'SLViewController' do |viewController|
    viewController.source_files = 'CSLUILibrary/SLViewController/*.{h,m}'
    viewController.resources    = 'CSLUILibrary/Resources/*.png'
    viewController.dependency 'CSLUILibrary/SLMVP'
  end
  s.subspec 'SLSearchController' do |searchController|
    searchController.source_files = 'CSLUILibrary/SLSearchController/*.{h,m}'
    searchController.dependency 'CSLUILibrary/SLView'
    searchController.dependency 'CSLUILibrary/SLImageView'
    searchController.dependency 'CSLUILibrary/SLViewController'
    searchController.dependency 'CSLUILibrary/SLButton'
  end
  s.subspec 'SLProgressView' do |progressView|
    progressView.source_files = 'CSLUILibrary/SLProgressView/*.{h,m}'
    progressView.dependency 'CSLUILibrary/SLView'
  end
  s.subspec 'SLSliderView' do |sliderView|
    sliderView.source_files = 'CSLUILibrary/SLSliderView/*.{h,m}'
    sliderView.dependency 'CSLUILibrary/SLProgressView'
  end
  s.subspec 'SLToast' do |toast|
    toast.source_files = 'CSLUILibrary/SLToast/*.{h,m}'
    toast.dependency 'CSLUILibrary/SLView'
    toast.dependency 'CSLUILibrary/SLImageView'
    toast.dependency 'CSLUILibrary/SLLabel'
  end
  s.subspec 'SLTableView' do |tableView|
    tableView.source_files = 'CSLUILibrary/SLTableView/*.{h,m}'
    tableView.dependency 'CSLUILibrary/SLModel'
  end
  s.subspec 'SLCollectionViewBase' do |collectionViewBase|
    collectionViewBase.source_files = 'CSLUILibrary/SLCollectionView/Base/*.{h,m}'
    collectionViewBase.dependency 'CSLUILibrary/SLModel'
  end
  s.subspec 'SLCardCollectionView' do |cardCollectionView|
    cardCollectionView.source_files = 'CSLUILibrary/SLCollectionView/CardCollect/*.{h,m}'
    cardCollectionView.dependency 'CSLUILibrary/SLCollectionViewBase'
    cardCollectionView.dependency 'CSLUILibrary/SLView'
  end
  s.subspec 'SLHorizontalCollectionView' do |horizontalCollectionView|
    horizontalCollectionView.source_files = 'CSLUILibrary/SLCollectionView/HorizonCollect/*.{h,m}'
    horizontalCollectionView.dependency 'CSLUILibrary/SLCollectionViewBase'
    horizontalCollectionView.dependency 'CSLUILibrary/SLView'
  end
  s.subspec 'SLNoRuleCollectionView' do |noRuleCollectionView|
    noRuleCollectionView.source_files = 'CSLUILibrary/SLCollectionView/NoRuleCollect/*.{h,m}'
    noRuleCollectionView.dependency 'CSLUILibrary/SLCollectionViewBase'
    noRuleCollectionView.dependency 'CSLUILibrary/SLView'
  end
  s.subspec 'SLPupCollectionView' do |pupCollectionView|
    pupCollectionView.source_files = 'CSLUILibrary/SLCollectionView/PupCollect/*.{h,m}'
    pupCollectionView.dependency 'CSLUILibrary/SLCollectionViewBase'
    pupCollectionView.dependency 'CSLUILibrary/SLView'
  end
  s.subspec 'SLRecycleCollectionView' do |recycleCollectionView|
    recycleCollectionView.source_files = 'CSLUILibrary/SLCollectionView/RecycleCollect/*.{h,m}'
    recycleCollectionView.dependency 'CSLUILibrary/SLCollectionViewBase'
    recycleCollectionView.dependency 'CSLUILibrary/SLScrollView'
    recycleCollectionView.dependency 'CSLUILibrary/SLView'
  end
  s.subspec 'SLStaticCollectionView' do |staticCollectionView|
    staticCollectionView.source_files = 'CSLUILibrary/SLCollectionView/StaticCollect/*.{h,m}'
    staticCollectionView.dependency 'CSLUILibrary/SLCollectionViewBase'
    staticCollectionView.dependency 'CSLUILibrary/SLView'
  end
  s.subspec 'SLPageableCollectionView' do |pageableCollectionView|
    pageableCollectionView.source_files = 'CSLUILibrary/SLCollectionView/PageableCollect/*.{h,m}'
    pageableCollectionView.dependency 'CSLUILibrary/SLCollectionViewBase'
    pageableCollectionView.dependency 'CSLUILibrary/SLStaticCollectionView'
    pageableCollectionView.dependency 'CSLUILibrary/SLRecycleCollectionView'
    pageableCollectionView.dependency 'CSLUILibrary/SLView'
  end
  s.subspec 'SLDropDownView' do |dropDownView|
    dropDownView.source_files = 'CSLUILibrary/SLDropDownView/*.{h,m}'
    dropDownView.dependency 'CSLUILibrary/SLCollectionViewBase'
    dropDownView.dependency 'CSLUILibrary/SLTableView'
    dropDownView.dependency 'CSLUILibrary/SLView'
  end
end
