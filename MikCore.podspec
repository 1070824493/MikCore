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

  s.homepage         = 'https://github.com/1070824493@qq.com/MikCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1070824493@qq.com' => 'tangyi.get@gmail.com' }
  s.source           = { :git => 'https://github.com/1070824493@qq.com/MikCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '13.0'
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  
  s.resource_bundles = {
    'MikCoreBundle' => ['MikCore/Assets.xcassets', 'MikCore/Gifs/*', 'MikCore/Fonts/*']
  }

  s.subspec 'MikFoundation' do |mf|
  
    mf.subspec 'NameSpace' do |a|
        a.source_files  = 'MikCore/Classes/MikFoundation/NameSpace/**/*'
        
        a.frameworks = 'UIKit'
    end
 
    mf.subspec 'Extensions' do |b|
        b.source_files  = 'MikCore/Classes/MikFoundation/Extensions/**/*'
        
        b.dependency 'Kingfisher'
        b.dependency 'MikCore/MikFoundation/NameSpace'

        b.frameworks = 'Photos'
    end

    mf.subspec 'MikValidateRegex' do |c|
        c.source_files  = 'MikCore/Classes/MikFoundation/MikValidateRegex/**/*'
        
        c.frameworks = 'Foundation'
    end
  
  mf.subspec 'MikMedia' do |d|
      d.source_files  = 'MikCore/Classes/MikFoundation/MikMedia/**/*'
        
        d.dependency 'ZLPhotoBrowser', '4.1.7'
        d.dependency 'MikCore/MikFoundation/Extensions'
        d.frameworks = 'Photos'
  end

  mf.subspec 'MikNetWork' do |e|
      e.source_files  = 'MikCore/Classes/MikFoundation/MikNetWork/**/*'
     
        e.dependency 'Alamofire'
        e.dependency 'HandyJSON'
        e.dependency 'MikCore/MikFoundation/Extensions'
        e.dependency 'MikCore/MikFoundation/MikLog'
        e.dependency 'RxSwift'
        e.dependency 'RxCocoa'
  end

    mf.subspec 'MikLog' do |f|
        f.source_files  = 'MikCore/Classes/MikFoundation/MikLog/**/*'
        f.dependency 'HandyJSON'
        f.dependency 'SwiftyBeaver', '1.9.5'
        f.dependency 'Firebase/Storage', '8.7.0'
        f.dependency 'Firebase/Auth', '8.7.0'
        f.dependency 'Firebase/Analytics', '8.7.0'
        f.dependency 'Firebase/Messaging', '8.7.0'
        f.dependency 'Firebase/Crashlytics', '8.7.0'
        f.dependency 'Firebase/DynamicLinks', '8.7.0'
        
        f.dependency 'MikCore/MikFoundation/Extensions'
        f.dependency 'MikCore/MikKit/MikToast'

    end

  end
  
  
  s.subspec 'MikKit' do |mk|

    mk.subspec 'MikDropBoxView' do |a|
        a.source_files  = 'MikCore/Classes/MikKit/MikDropBoxView/**/*'
        
        a.dependency 'SnapKit'
        a.dependency 'MikCore/MikFoundation/Extensions'
    end
    
    
    mk.subspec 'MikCalendarView' do |b|
        b.source_files  = 'MikCore/Classes/MikKit/MikCalendarView/**/*'
        
        b.dependency 'SnapKit'
        b.dependency 'JTAppleCalendar', '8.0.3'
        b.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikPaymentCardsOCR' do |c|
        c.source_files  = 'MikCore/Classes/MikKit/MikPaymentCardsOCR/**/*'
        
        c.dependency 'SnapKit'
        c.dependency 'MikCore/MikFoundation/Extensions'
        c.dependency 'MikCore/MikKit/MikToast'
        
        c.frameworks = 'Vision', 'VisionKit'
    end

    mk.subspec 'MikSegmentedView' do |e|
        e.source_files  = 'MikCore/Classes/MikKit/MikSegmentedView/**/*'
        
        e.dependency 'SnapKit'
        e.dependency 'JXSegmentedView', '1.2.7'
        e.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikAlertView' do |f|
        f.source_files  = 'MikCore/Classes/MikKit/MikAlertView/**/*'
        
        f.dependency 'SnapKit'
        f.dependency 'MikCore/MikFoundation/Extensions'
        f.dependency 'MikCore/MikKit/MikTextViewCell'
        f.dependency 'RxSwift'
        f.dependency 'RxCocoa'
    end

    mk.subspec 'MikPopoverView' do |g|
        g.source_files  = 'MikCore/Classes/MikKit/MikPopoverView/**/*'
        
        g.dependency 'SnapKit'
        g.dependency 'ActiveLabel', '1.1.0'
        g.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikGuideView' do |h|
        h.source_files  = 'MikCore/Classes/MikKit/MikGuideView/**/*'
        
        h.dependency 'SnapKit'
        h.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikTextViewCell' do |i|
        i.source_files  = 'MikCore/Classes/MikKit/MikTextViewCell/**/*'
        
        i.dependency 'SnapKit'
        i.dependency 'RxSwift'
        i.dependency 'MikCore/MikFoundation/Extensions'
        i.dependency 'MikCore/MikFoundation/MikValidateRegex'
    end

    mk.subspec 'MikStarRateView' do |j|
        j.source_files  = 'MikCore/Classes/MikKit/MikStarRateView/**/*'
        
        j.dependency 'SnapKit'
        j.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikFilterViewCell' do |k|
        k.source_files  = 'MikCore/Classes/MikKit/MikFilterViewCell/**/*'
        
        k.dependency 'SnapKit'
        k.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikBottomButtonView' do |l|
        l.source_files  = 'MikCore/Classes/MikKit/MikBottomButtonView/**/*'
        
        l.dependency 'SnapKit'
        l.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikDotProgressView' do |m|
        m.source_files  = 'MikCore/Classes/MikKit/MikDotProgressView/**/*'
        
        m.dependency 'SnapKit'
        m.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikImageView' do |n|
        n.source_files  = 'MikCore/Classes/MikKit/MikImageView/**/*'
           
        n.dependency 'SnapKit'
        n.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikGrowTextView' do |o|
        o.source_files  = 'MikCore/Classes/MikKit/MikGrowTextView/**/*'
        
        o.dependency 'SnapKit'
        o.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikScrollView' do |p|
        p.source_files  = 'MikCore/Classes/MikKit/MikScrollView/**/*'
        
        p.dependency 'SnapKit'
        p.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikEmptyView' do |q|
        q.source_files  = 'MikCore/Classes/MikKit/MikEmptyView/**/*'
        
        q.dependency 'SnapKit'
        q.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikToast' do |r|
        r.source_files  = 'MikCore/Classes/MikKit/MikToast/**/*'
        
        r.dependency 'SnapKit'
        r.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikBottomPopController' do |t|
        t.source_files  = 'MikCore/Classes/MikKit/MikBottomPopController/**/*'
        
        t.dependency 'SnapKit'
        t.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikStepView' do |u|
        u.source_files  = 'MikCore/Classes/MikKit/MikStepView/**/*'
        
        u.dependency 'SnapKit'
        u.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikButton' do |v|
        v.source_files  = 'MikCore/Classes/MikKit/MikButton/**/*'
        
        v.dependency 'SnapKit'
        v.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikNavigationController' do |w|
        w.source_files  = 'MikCore/Classes/MikKit/MikNavigationController/**/*'
        
        w.dependency 'SnapKit'
        w.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikNumberControl' do |x|
        x.source_files  = 'MikCore/Classes/MikKit/MikNumberControl/**/*'
        
        x.dependency 'SnapKit'
        x.dependency 'MikCore/MikFoundation/Extensions'
    end

    mk.subspec 'MikSwitch' do |y|
        y.source_files  = 'MikCore/Classes/MikKit/MikSwitch/**/*'
        
        y.dependency 'SnapKit'
        y.dependency 'MikCore/MikFoundation/Extensions'
    end
    
    mk.subspec 'MikPickerView' do |z|
        z.source_files  = 'MikCore/Classes/MikKit/MikPickerView/**/*'
        
        z.dependency 'SnapKit'
        z.dependency 'MikCore/MikFoundation/Extensions'
        z.dependency 'MikCore/MikKit/MikBottomPopController'
    end
    
    mk.subspec 'MikPullToRefresh' do |aa|
        aa.source_files  = 'MikCore/Classes/MikKit/MikPullToRefresh/**/*'
        
        aa.dependency 'Kingfisher'
        aa.dependency 'ESPullToRefresh'
        aa.dependency 'MikCore/MikFoundation/NameSpace'
        aa.dependency 'MikCore/MikFoundation/Extensions'
    end
    
    mk.subspec 'MikCommon' do |bb|
        bb.source_files  = 'MikCore/Classes/MikKit/MikCommon/**/*'
    end

    mk.subspec 'MikTextField' do |cc|
        cc.source_files  = 'MikCore/Classes/MikKit/MikTextField/**/*'
        cc.dependency 'RxSwift'
        cc.dependency 'RxCocoa'
        cc.dependency 'MikCore/MikFoundation/NameSpace'
        cc.dependency 'MikCore/MikFoundation/Extensions'
        cc.dependency 'SnapKit'
        
        cc.frameworks = 'UIKit', 'Foundation'
        
    end
    
    mk.subspec 'MikOmitTextView' do |dd|
        dd.source_files  = 'MikCore/Classes/MikKit/MikOmitTextView/**/*'
        
        dd.dependency 'SnapKit'
        
        dd.frameworks = 'UIKit', 'Foundation'
        
    end
    
  end
  
end
