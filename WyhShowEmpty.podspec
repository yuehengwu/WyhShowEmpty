Pod::Spec.new do |s|
  s.name             = 'WyhShowEmpty'
  s.version          = '1.0.4'
  s.summary          = 'Quick to show empty-view in anywhere.'

  s.homepage         = 'https://github.com/XiaoWuTongZhi/WyhShowEmpty'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "wyh" => "609223770@qq.com" }
  s.source           = { :git => "https://github.com/XiaoWuTongZhi/WyhShowEmpty.git", :tag => "v#{s.version.to_s}" }

  s.ios.deployment_target = '8.0'

  s.source_files = 'WyhShowEmpty/Classes/*.{h,m}'

  s.resources = 'WyhShowEmpty/Classes/WyhEmpty.bundle'
  s.dependency 'Masonry'
end
