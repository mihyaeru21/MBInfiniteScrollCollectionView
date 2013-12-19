Pod::Spec.new do |s|
  s.name          = "MBInfiniteScrollCollectionView"
  s.version       = "0.1"
  s.summary       = "infinite scroll UICollectionView"
  s.homepage      = "https://github.com/mihyaeru21/MBInfiniteScrollCollectionView"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "Mihyaeru" => "mihyaeru.app@gmail.com" }
  s.platform      = :ios, '6.0'
  s.source        = { :git => "https://github.com/mihyaeru21/MBInfiniteScrollCollectionView.git", :tag => "0.1" }
  s.source_files  = 'MBInfiniteScrollCollectionView/**/*.{h,m}'
  s.exclude_files = 'MBInfiniteScrollCollectionView/**/*Tests.{h,m}'
  s.requires_arc  = true
end
