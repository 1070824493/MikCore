#
# Be sure to run `pod lib lint MikCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MikCore'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MikCore.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/1070824493/MikCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1070824493@qq.com' => 'tangyi.get@gmail.com' }
  s.source           = { :git => 'https://github.com/1070824493/MikCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '13.0'
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  
  s.resource_bundles = {
    'MikCoreBundle' => ['MikCore/Assets/Assets.xcassets', 'MikCore/Gifs/*', 'MikCore/Fonts/*']
  }

  s.subspec 'MikFoundation' do |mf|

    mf.subspec 'NameSpace' do |a|
        a.source_files  = 'MikCore/Classes/MikFoundation/NameSpace/**/*'
        a.frameworks = 'UIKit', 'Foundation'
        a.frameworks = 'Photos'
        a.dependency 'Kingfisher', '7.0.0'
        a.dependency 'KingfisherWebP', '1.4.0'
    end


    mf.subspec 'MikValidateRegex' do |c|
        c.source_files  = 'MikCore/Classes/MikFoundation/MikValidateRegex/**/*'
        
        c.frameworks = 'Foundation'
    end
  
    mf.subspec 'MikMedia' do |d|
      d.source_files  = 'MikCore/Classes/MikFoundation/MikMedia/**/*'

        d.dependency 'ZLPhotoBrowser'
        d.dependency 'MikCore/MikFoundation/NameSpace'
        d.dependency 'MikCore/MikFoundation/MikLogger'
        d.frameworks = 'Photos'
    end

    mf.subspec 'MikNetWork' do |e|
      e.source_files  = 'MikCore/Classes/MikFoundation/MikNetWork/**/*'

        e.dependency 'Alamofire'
        e.dependency 'HandyJSON'
        e.dependency 'MikCore/MikFoundation/NameSpace'
        e.dependency 'MikCore/MikFoundation/MikLogger'
        e.dependency 'RxSwift'
        e.dependency 'RxCocoa'
    end

    mf.subspec 'MikLogger' do |f|
        f.source_files  = 'MikCore/Classes/MikFoundation/MikLogger/**/*'
        f.dependency 'HandyJSON'
        f.dependency 'SwiftyJSON'
        f.dependency 'MikCore/MikFoundation/NameSpace'
        f.dependency 'MikCore/MikKit/MikToast'

    end

  end
  
  
  s.subspec 'MikKit' do |mk|
    
    mk.subspec 'MikCalendarView' do |b|
        b.source_files  = 'MikCore/Classes/MikKit/MikCalendarView/**/*'
        
        b.dependency 'SnapKit'
        b.dependency 'JTAppleCalendar'
        b.dependency 'MikCore/MikFoundation/NameSpace'
    end

    mk.subspec 'MikSegmentedView' do |e|
        e.source_files  = 'MikCore/Classes/MikKit/MikSegmentedView/**/*'
        
        e.dependency 'SnapKit'
        e.dependency 'JXSegmentedView'
        e.dependency 'MikCore/MikFoundation/NameSpace'
    end

    mk.subspec 'MikAlertView' do |f|
        f.source_files  = 'MikCore/Classes/MikKit/MikAlertView/**/*'
        
        f.dependency 'SnapKit'
        f.dependency 'MikCore/MikFoundation/NameSpace'
        f.dependency 'RxSwift'
        f.dependency 'RxCocoa'
    end

    mk.subspec 'MikPopoverView' do |g|
        g.source_files  = 'MikCore/Classes/MikKit/MikPopoverView/**/*'
        
        g.dependency 'SnapKit'
        g.dependency 'ActiveLabel'
        g.dependency 'MikCore/MikFoundation/NameSpace'
    end


    mk.subspec 'MikStarView' do |j|
        j.source_files  = 'MikCore/Classes/MikKit/MikStarView/**/*'
        j.dependency 'SnapKit'
        j.dependency 'MikCore/MikFoundation/NameSpace'
        j.dependency 'RxSwift'
        j.dependency 'RxCocoa'
    end

    mk.subspec 'MikDotProgressView' do |m|
        m.source_files  = 'MikCore/Classes/MikKit/MikDotProgressView/**/*'
        
        m.dependency 'SnapKit'
        m.dependency 'MikCore/MikFoundation/NameSpace'
    end

    mk.subspec 'MikImageView' do |n|
        n.source_files  = 'MikCore/Classes/MikKit/MikImageView/**/*'
           
        n.dependency 'SnapKit'
        n.dependency 'MikCore/MikFoundation/NameSpace'
    end

    mk.subspec 'MikGrowTextView' do |o|
        o.source_files  = 'MikCore/Classes/MikKit/MikGrowTextView/**/*'
        
        o.dependency 'SnapKit'
        o.dependency 'MikCore/MikFoundation/NameSpace'
    end

    mk.subspec 'MikToast' do |r|
        r.source_files  = 'MikCore/Classes/MikKit/MikToast/**/*'
        
        r.dependency 'SnapKit'
        r.dependency 'MikCore/MikFoundation/NameSpace'
    end

    mk.subspec 'MikNavigationController' do |w|
        w.source_files  = 'MikCore/Classes/MikKit/MikNavigationController/**/*'
        
        w.dependency 'SnapKit'
        w.dependency 'MikCore/MikFoundation/NameSpace'
        w.dependency 'RxSwift'
        w.dependency 'RxCocoa'
    end

    mk.subspec 'MikNumberControl' do |x|
        x.source_files  = 'MikCore/Classes/MikKit/MikNumberControl/**/*'
        
        x.dependency 'SnapKit'
        x.dependency 'MikCore/MikFoundation/NameSpace'
    end

    mk.subspec 'MikSwitch' do |y|
        y.source_files  = 'MikCore/Classes/MikKit/MikSwitch/**/*'
        
        y.dependency 'SnapKit'
        y.dependency 'MikCore/MikFoundation/NameSpace'
    end
    
    mk.subspec 'MikBottomPopController' do |t|
        t.source_files  = 'MikCore/Classes/MikKit/MikBottomPopController/**/*'
        
        t.dependency 'SnapKit'
        t.dependency 'MikCore/MikFoundation/NameSpace'
        t.dependency 'MikCore/MikKit/MikNavigationController'
    end
    
    mk.subspec 'MikPickerView' do |z|
        z.source_files  = 'MikCore/Classes/MikKit/MikPickerView/**/*'
        
        z.dependency 'SnapKit'
        z.dependency 'MikCore/MikFoundation/NameSpace'
        z.dependency 'MikCore/MikKit/MikBottomPopController'
    end

    mk.subspec 'MikTextField' do |cc|
        cc.source_files  = 'MikCore/Classes/MikKit/MikTextField/**/*'
        cc.dependency 'RxSwift'
        cc.dependency 'RxCocoa'
        cc.dependency 'MikCore/MikFoundation/NameSpace'
        cc.dependency 'SnapKit'
        
        cc.frameworks = 'UIKit', 'Foundation'
        
    end
    
  end
  
end
