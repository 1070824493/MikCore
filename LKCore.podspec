#
# Be sure to run `pod lib lint LiveKitCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'LKCore'
    s.version          = '0.1.0'
    s.summary          = 'A short description of LiveKitCore.'
    s.homepage         = 'https://github.com/1070824493/LiveKitCore'
  
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { '1070824493' => 'tangyi.get@gmail.com' }
    s.source           = { :git => 'git@bitbucket.org:lktechnology/lk-mobile-core.git', :tag => s.version.to_s }
    s.platform     = :ios, '13.0'
    s.ios.deployment_target = '13.0'
    s.swift_version = '5.0'
    
    s.resource_bundles = {
        'LKCoreBundle' => ['LKCore/Assets/Assets.xcassets', 'LKCore/Assets/Gifs/*', 'LKCore/Assets/Fonts/*']
    }
    
    s.subspec 'LKFoundation' do |mf|
        
        mf.subspec 'NameSpace' do |a|
            a.source_files  = 'LKCore/Classes/LKFoundation/NameSpace/**/*'
            a.frameworks = 'UIKit', 'Foundation'
            a.frameworks = 'Photos'
            a.dependency 'Kingfisher', '7.6.2'
            a.dependency 'KingfisherWebP', '1.4.0'
        end
        
        mf.subspec 'LKValidateRegex' do |c|
            c.source_files  = 'LKCore/Classes/LKFoundation/LKValidateRegex/**/*'
            
            c.frameworks = 'Foundation'
        end
        
        mf.subspec 'LKMedia' do |d|
            d.source_files  = 'LKCore/Classes/LKFoundation/LKMedia/**/*'
            
            d.dependency 'ZLPhotoBrowser', '4.1.7'
            d.dependency 'LKCore/LKFoundation/NameSpace'
            d.frameworks = 'Photos'
        end
        
        mf.subspec 'LKNetWork' do |e|
            e.source_files  = 'LKCore/Classes/LKFoundation/LKNetWork/**/*'
            
            e.dependency 'Alamofire', '5.4.4'
            e.dependency 'HandyJSON', '5.0.2'
            e.dependency 'LKCore/LKFoundation/NameSpace'
            e.dependency 'RxSwift', '6.2.0'
            e.dependency 'RxCocoa', '6.2.0'
        end
        
    end
    
    
    s.subspec 'LKKit' do |mk|
        
        mk.subspec 'LKDropBoxView' do |a|
            a.source_files  = 'LKCore/Classes/LKKit/LKDropBoxView/**/*'
            
            a.dependency 'SnapKit', '5.0.1'
            a.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKLockSlider' do |d|
            d.source_files  = 'LKCore/Classes/LKKit/LKLockSlider/**/*'
            d.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKSegmentedView' do |e|
            e.source_files  = 'LKCore/Classes/LKKit/LKSegmentedView/**/*'
            
            e.dependency 'SnapKit', '5.0.1'
            e.dependency 'JXSegmentedView', '1.2.7'
            e.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKAlertView' do |f|
            f.source_files  = 'LKCore/Classes/LKKit/LKAlertView/**/*'
            
            f.dependency 'SnapKit', '5.0.1'
            f.dependency 'LKCore/LKFoundation/NameSpace'
            f.dependency 'LKCore/LKKit/LKTextViewCell'
            f.dependency 'LKCore/LKKit/LKTextField'
            f.dependency 'LKCore/LKKit/LKButton'
            f.dependency 'RxSwift', '6.2.0'
            f.dependency 'RxCocoa', '6.2.0'
        end
        
        mk.subspec 'LKPopoverView' do |g|
            g.source_files  = 'LKCore/Classes/LKKit/LKPopoverView/**/*'
            
            g.dependency 'SnapKit', '5.0.1'
            g.dependency 'ActiveLabel', '1.1.0'
            g.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKGuideView' do |h|
            h.source_files  = 'LKCore/Classes/LKKit/LKGuideView/**/*'
            
            h.dependency 'SnapKit', '5.0.1'
            h.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKTextViewCell' do |i|
            i.source_files  = 'LKCore/Classes/LKKit/LKTextViewCell/**/*'
            
            i.dependency 'SnapKit', '5.0.1'
            i.dependency 'RxSwift', '6.2.0'
            i.dependency 'LKCore/LKFoundation/NameSpace'
            i.dependency 'LKCore/LKFoundation/LKValidateRegex'
        end
        
        mk.subspec 'LKStarRateView' do |j|
            j.source_files  = 'LKCore/Classes/LKKit/LKStarRateView/**/*'
            
            j.dependency 'SnapKit', '5.0.1'
            j.dependency 'LKCore/LKFoundation/NameSpace'
            j.dependency 'RxSwift', '6.2.0'
            j.dependency 'RxCocoa', '6.2.0'
        end
        
        mk.subspec 'LKFilterViewCell' do |k|
            k.source_files  = 'LKCore/Classes/LKKit/LKFilterViewCell/**/*'
            k.dependency 'SnapKit', '5.0.1'
            k.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKBottomButtonView' do |l|
            l.source_files  = 'LKCore/Classes/LKKit/LKBottomButtonView/**/*'
            l.dependency 'SnapKit', '5.0.1'
            l.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKDotProgressView' do |m|
            m.source_files  = 'LKCore/Classes/LKKit/LKDotProgressView/**/*'
            m.dependency 'SnapKit', '5.0.1'
            m.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKImageView' do |n|
            n.source_files  = 'LKCore/Classes/LKKit/LKImageView/**/*'
            n.dependency 'SnapKit', '5.0.1'
            n.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKGrowTextView' do |o|
            o.source_files  = 'LKCore/Classes/LKKit/LKGrowTextView/**/*'
            o.dependency 'SnapKit', '5.0.1'
            o.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKScrollView' do |p|
            p.source_files  = 'LKCore/Classes/LKKit/LKScrollView/**/*'
            p.dependency 'SnapKit', '5.0.1'
            p.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKEmptyView' do |q|
            q.source_files  = 'LKCore/Classes/LKKit/LKEmptyView/**/*'
            q.dependency 'SnapKit', '5.0.1'
            q.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKToast' do |r|
            r.source_files  = 'LKCore/Classes/LKKit/LKToast/**/*'
            r.dependency 'SnapKit', '5.0.1'
            r.dependency 'LKCore/LKFoundation/NameSpace'
        end

        mk.subspec 'LKBaseViewController' do |s|
            s.source_files  = 'LKCore/Classes/LKKit/LKBaseViewController/**/*'
            s.dependency 'LKCore/LKFoundation/NameSpace'
        end

        
        mk.subspec 'LKBottomPopController' do |t|
            t.source_files  = 'LKCore/Classes/LKKit/LKBottomPopController/**/*'
            t.dependency 'SnapKit', '5.0.1'
            t.dependency 'LKCore/LKFoundation/NameSpace'
            t.dependency 'LKCore/LKKit/LKNavigationController'
            t.dependency 'LKCore/LKKit/LKBaseViewController'
        end
        
        mk.subspec 'LKStepView' do |u|
            u.source_files  = 'LKCore/Classes/LKKit/LKStepView/**/*'
            u.dependency 'SnapKit', '5.0.1'
            u.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKButton' do |v|
            v.source_files  = 'LKCore/Classes/LKKit/LKButton/**/*'
            v.dependency 'SnapKit', '5.0.1'
            v.dependency 'LKCore/LKFoundation/NameSpace'
            
        end
        
        mk.subspec 'LKNavigationController' do |w|
            w.source_files  = 'LKCore/Classes/LKKit/LKNavigationController/**/*'
            w.dependency 'SnapKit', '5.0.1'
            w.dependency 'LKCore/LKFoundation/NameSpace'
            w.dependency 'RxSwift'
            w.dependency 'RxCocoa'
        end
        
        mk.subspec 'LKNumberControl' do |x|
            x.source_files  = 'LKCore/Classes/LKKit/LKNumberControl/**/*'
            x.dependency 'SnapKit', '5.0.1'
            x.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKSwitch' do |y|
            y.source_files  = 'LKCore/Classes/LKKit/LKSwitch/**/*'
            y.dependency 'SnapKit', '5.0.1'
            y.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKPickerView' do |z|
            z.source_files  = 'LKCore/Classes/LKKit/LKPickerView/**/*'
            z.dependency 'SnapKit', '5.0.1'
            z.dependency 'LKCore/LKFoundation/NameSpace'
            z.dependency 'LKCore/LKKit/LKBottomPopController'
        end
        
        mk.subspec 'LKPullToRefresh' do |aa|
            aa.source_files  = 'LKCore/Classes/LKKit/LKPullToRefresh/**/*'
            aa.dependency 'Kingfisher', '7.6.2'
            aa.dependency 'MJRefresh', '3.7.5'
            aa.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKCommon' do |bb|
            bb.source_files  = 'LKCore/Classes/LKKit/LKCommon/**/*'
            bb.dependency 'LKCore/LKFoundation/NameSpace'
        end
        
        mk.subspec 'LKTextField' do |cc|
            cc.source_files  = 'LKCore/Classes/LKKit/LKTextField/**/*'
            cc.dependency 'RxSwift', '6.2.0'
            cc.dependency 'RxCocoa', '6.2.0'
            cc.dependency 'LKCore/LKFoundation/NameSpace'
            cc.dependency 'SnapKit', '5.0.1'
        end
        
        mk.subspec 'LKOmitTextView' do |dd|
            dd.source_files  = 'LKCore/Classes/LKKit/LKOmitTextView/**/*'
            dd.dependency 'SnapKit', '5.0.1'
        end
        
    end
    
end
