Pod::Spec.new do |s|
    s.name          = 'MikCore'
    s.version       = '0.8.4'
    s.summary       = 'michaels core library'
    s.homepage      = 'https://bitbucket.org/ordili/mikcoredemo'
    s.license       = { :type => 'MIT', :file => 'license' }
    s.author        = { 'Mik' => 'wei5@michaels.com' }
    s.source      	 = { :git => 'git@bitbucket.org:miktechnology/mik-mobile-core.git', :tag => s.version.to_s }
    s.platform     = :ios, '13.0'
    s.ios.deployment_target = '13.0'
    s.swift_version = '5.0'
    
    s.resource_bundles = {
        'MikCoreBundle' => ['MikCore/Assets/Assets.xcassets', 'MikCore/Assets/Gifs/*', 'MikCore/Assets/Fonts/*']
    }
    
    s.subspec 'MikFoundation' do |mf|
        
        mf.subspec 'NameSpace' do |a|
            a.source_files  = 'MikCore/Classes/MikFoundation/NameSpace/**/*'
            a.frameworks = 'UIKit', 'Foundation'
            a.frameworks = 'Photos'
            a.dependency 'Kingfisher', '7.8.1'
            a.dependency 'KingfisherWebP', '1.5.2'
        end
        
        mf.subspec 'MikValidateRegex' do |c|
            c.source_files  = 'MikCore/Classes/MikFoundation/MikValidateRegex/**/*'
            
            c.frameworks = 'Foundation'
        end
        
        mf.subspec 'MikMedia' do |d|
            d.source_files  = 'MikCore/Classes/MikFoundation/MikMedia/**/*'
            
            d.dependency 'ZLPhotoBrowser', '4.1.7'
            d.dependency 'MikCore/MikFoundation/NameSpace'
            d.frameworks = 'Photos'
        end
        
        mf.subspec 'MikNetWork' do |e|
            e.source_files  = 'MikCore/Classes/MikFoundation/MikNetWork/**/*'
            
            e.dependency 'Alamofire', '5.4.4'
            e.dependency 'HandyJSON', '5.0.2'
            e.dependency 'MikCore/MikFoundation/NameSpace'
            e.dependency 'RxSwift', '6.2.0'
            e.dependency 'RxCocoa', '6.2.0'
            e.dependency 'SwiftyJSON', '5.0.1'
        end
        
    end
    
    
    s.subspec 'MikKit' do |mk|
        
        mk.subspec 'MikDropBoxView' do |a|
            a.source_files  = 'MikCore/Classes/MikKit/MikDropBoxView/**/*'
            
            a.dependency 'SnapKit', '5.0.1'
            a.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        
        mk.subspec 'MikCalendarView' do |b|
            b.source_files  = 'MikCore/Classes/MikKit/MikCalendarView/**/*'
            
            b.dependency 'SnapKit', '5.0.1'
            b.dependency 'JTAppleCalendar', '8.0.3'
            b.dependency 'MikCore/MikFoundation/NameSpace'
            
        end
        
        mk.subspec 'MikPaymentCardsOCR' do |c|
            c.source_files  = 'MikCore/Classes/MikKit/MikPaymentCardsOCR/**/*'
            
            c.dependency 'SnapKit', '5.0.1'
            c.dependency 'MikCore/MikFoundation/NameSpace'
            c.dependency 'MikCore/MikKit/MikToast'
            c.frameworks = 'Vision', 'VisionKit'
        end
        
        mk.subspec 'MikLockSlider' do |d|
            d.source_files  = 'MikCore/Classes/MikKit/MikLockSlider/**/*'
            d.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikSegmentedView' do |e|
            e.source_files  = 'MikCore/Classes/MikKit/MikSegmentedView/**/*'
            
            e.dependency 'SnapKit', '5.0.1'
            e.dependency 'JXSegmentedView', '1.2.7'
            e.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikAlertView' do |f|
            f.source_files  = 'MikCore/Classes/MikKit/MikAlertView/**/*'
            
            f.dependency 'SnapKit', '5.0.1'
            f.dependency 'MikCore/MikFoundation/NameSpace'
            f.dependency 'MikCore/MikKit/MikTextViewCell'
            f.dependency 'MikCore/MikKit/MikTextField'
            f.dependency 'MikCore/MikKit/MikButton'
            f.dependency 'RxSwift', '6.2.0'
            f.dependency 'RxCocoa', '6.2.0'
        end
        
        mk.subspec 'MikPopoverView' do |g|
            g.source_files  = 'MikCore/Classes/MikKit/MikPopoverView/**/*'
            
            g.dependency 'SnapKit', '5.0.1'
            g.dependency 'ActiveLabel', '1.1.0'
            g.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikGuideView' do |h|
            h.source_files  = 'MikCore/Classes/MikKit/MikGuideView/**/*'
            
            h.dependency 'SnapKit', '5.0.1'
            h.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikTextViewCell' do |i|
            i.source_files  = 'MikCore/Classes/MikKit/MikTextViewCell/**/*'
            
            i.dependency 'SnapKit', '5.0.1'
            i.dependency 'RxSwift', '6.2.0'
            i.dependency 'MikCore/MikFoundation/NameSpace'
            i.dependency 'MikCore/MikFoundation/MikValidateRegex'
        end
        
        mk.subspec 'MikStarRateView' do |j|
            j.source_files  = 'MikCore/Classes/MikKit/MikStarRateView/**/*'
            
            j.dependency 'SnapKit', '5.0.1'
            j.dependency 'MikCore/MikFoundation/NameSpace'
            j.dependency 'RxSwift', '6.2.0'
            j.dependency 'RxCocoa', '6.2.0'
        end
        
        mk.subspec 'MikFilterViewCell' do |k|
            k.source_files  = 'MikCore/Classes/MikKit/MikFilterViewCell/**/*'
            k.dependency 'SnapKit', '5.0.1'
            k.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikBottomButtonView' do |l|
            l.source_files  = 'MikCore/Classes/MikKit/MikBottomButtonView/**/*'
            l.dependency 'SnapKit', '5.0.1'
            l.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikDotProgressView' do |m|
            m.source_files  = 'MikCore/Classes/MikKit/MikDotProgressView/**/*'
            m.dependency 'SnapKit', '5.0.1'
            m.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikImageView' do |n|
            n.source_files  = 'MikCore/Classes/MikKit/MikImageView/**/*'
            n.dependency 'SnapKit', '5.0.1'
            n.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikGrowTextView' do |o|
            o.source_files  = 'MikCore/Classes/MikKit/MikGrowTextView/**/*'
            o.dependency 'SnapKit', '5.0.1'
            o.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikScrollView' do |p|
            p.source_files  = 'MikCore/Classes/MikKit/MikScrollView/**/*'
            p.dependency 'SnapKit', '5.0.1'
            p.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikEmptyView' do |q|
            q.source_files  = 'MikCore/Classes/MikKit/MikEmptyView/**/*'
            q.dependency 'SnapKit', '5.0.1'
            q.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikToast' do |r|
            r.source_files  = 'MikCore/Classes/MikKit/MikToast/**/*'
            r.dependency 'SnapKit', '5.0.1'
            r.dependency 'MikCore/MikFoundation/NameSpace'
        end

        mk.subspec 'MikBaseViewController' do |s|
            s.source_files  = 'MikCore/Classes/MikKit/MikBaseViewController/**/*'
            s.dependency 'MikCore/MikFoundation/NameSpace'
        end

        
        mk.subspec 'MikBottomPopController' do |t|
            t.source_files  = 'MikCore/Classes/MikKit/MikBottomPopController/**/*'
            t.dependency 'SnapKit', '5.0.1'
            t.dependency 'MikCore/MikFoundation/NameSpace'
            t.dependency 'MikCore/MikKit/MikNavigationController'
            t.dependency 'MikCore/MikKit/MikBaseViewController'
        end
        
        mk.subspec 'MikStepView' do |u|
            u.source_files  = 'MikCore/Classes/MikKit/MikStepView/**/*'
            u.dependency 'SnapKit', '5.0.1'
            u.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikButton' do |v|
            v.source_files  = 'MikCore/Classes/MikKit/MikButton/**/*'
            v.dependency 'SnapKit', '5.0.1'
            v.dependency 'MikCore/MikFoundation/NameSpace'
            
        end
        
        mk.subspec 'MikNavigationController' do |w|
            w.source_files  = 'MikCore/Classes/MikKit/MikNavigationController/**/*'
            w.dependency 'SnapKit', '5.0.1'
            w.dependency 'MikCore/MikFoundation/NameSpace'
            w.dependency 'RxSwift'
            w.dependency 'RxCocoa'
        end
        
        mk.subspec 'MikNumberControl' do |x|
            x.source_files  = 'MikCore/Classes/MikKit/MikNumberControl/**/*'
            x.dependency 'SnapKit', '5.0.1'
            x.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikSwitch' do |y|
            y.source_files  = 'MikCore/Classes/MikKit/MikSwitch/**/*'
            y.dependency 'SnapKit', '5.0.1'
            y.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikPickerView' do |z|
            z.source_files  = 'MikCore/Classes/MikKit/MikPickerView/**/*'
            z.dependency 'SnapKit', '5.0.1'
            z.dependency 'MikCore/MikFoundation/NameSpace'
            z.dependency 'MikCore/MikKit/MikBottomPopController'
        end
        
        mk.subspec 'MikPullToRefresh' do |aa|
            aa.source_files  = 'MikCore/Classes/MikKit/MikPullToRefresh/**/*'
            aa.dependency 'Kingfisher', '7.8.1'
            aa.dependency 'MJRefresh', '3.7.5'
            aa.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikCommon' do |bb|
            bb.source_files  = 'MikCore/Classes/MikKit/MikCommon/**/*'
            bb.dependency 'MikCore/MikFoundation/NameSpace'
        end
        
        mk.subspec 'MikTextField' do |cc|
            cc.source_files  = 'MikCore/Classes/MikKit/MikTextField/**/*'
            cc.dependency 'RxSwift', '6.2.0'
            cc.dependency 'RxCocoa', '6.2.0'
            cc.dependency 'MikCore/MikFoundation/NameSpace'
            cc.dependency 'SnapKit', '5.0.1'
        end
        
        mk.subspec 'MikOmitTextView' do |dd|
            dd.source_files  = 'MikCore/Classes/MikKit/MikOmitTextView/**/*'
            dd.dependency 'SnapKit', '5.0.1'
        end
        
    end
    
end
