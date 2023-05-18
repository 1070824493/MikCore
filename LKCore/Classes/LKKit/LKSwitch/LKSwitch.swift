//
//  LKSwitch.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/29.
//

import UIKit
import SnapKit


//open class LKSwitch: UISwitch {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        thumbTintColor = UIColor.lk.general(.hexFFFFFF)
//
//        onTintColor = UIColor.lk.general(.hex00856D)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}


public class LKSwitch: UISwitch {
    /// Dot style
    public enum DotStyle : Equatable{
        /// default
        case none
        /// add image
        case img(onImg : UIImage?,offImg : UIImage?)
        /// add text
        case text(onText : String?,offText : String?)
        /// add text
        case textAtt(onText: NSAttributedString?,offText : NSAttributedString?)
    }
    
    private var titleLabel : UILabel?
    private var imageView : UIImageView?
    public override var isOn: Bool{
        didSet{
            self.changeDotStyle()
        }
    }
    public var dotStyle : LKSwitch.DotStyle = .none {
        didSet{
            setupDotView()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        thumbTintColor = UIColor.lk.general(.hexFFFFFF)
        backgroundColor = UIColor.lk.general(.hexBDBDBD)
        onTintColor = UIColor.lk.general(.hexCF1F2E)
        addTarget(self, action: #selector(changeDotStyle), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.height / 2.0
    }
}
extension LKSwitch {
    private func setupDotView(){
        removeDotView()
        guard dotStyle != .none else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [self] in
            let sub1 = self.subviews
            var supOnImgV : UIImageView?
            for v1 in sub1 {
                let sub2 = v1.subviews
                for v2  in sub2 {
                    /// ios12 get
                    if let imgV = v2 as? UIImageView , imgV.frame.size.width == 43 , imgV.frame.size.height == 43 {
                        supOnImgV = imgV
                        break
                    }
                    /// ios 13 get
                    let sub3 = v2.subviews
                    for v3 in sub3 {
                        if let imgV = v3 as? UIImageView , imgV.frame.size.width == 43 , imgV.frame.size.height == 43 {
                            supOnImgV = imgV
                            break
                        }
                    }
                }
            }
            if let imgV = supOnImgV {
               removeDotView()
                var tmpView : UIView?
                switch dotStyle {
                case .img(_,_):
                    let imgView = UIImageView()
                    self.imageView = imgView
                    tmpView = imgView
                case .textAtt(_, _),.text(_ , _):
                    let aLabel = UILabel()
                    aLabel.textAlignment = .center
                    self.titleLabel = aLabel
                    tmpView = aLabel
                default:
                    break
                }
                if let view = tmpView {
                    imgV.addSubview(view)
                    /// Small white spot range is (8, 5, 27, 27)
                    view.snp.remakeConstraints { (maker) in
                        maker.width.height.equalTo(27)
                        maker.top.equalTo(5)
                        maker.left.equalTo(8)
                    }
                    changeDotStyle()
                }
            }
            
        }
    }
    private func removeDotView(){
        titleLabel?.removeFromSuperview()
        imageView?.removeFromSuperview()
        titleLabel = nil
        imageView = nil
    }
    @objc private func changeDotStyle(){
        switch dotStyle {
        case .img(let onImg, let offImg):
                imageView?.image = isOn ? onImg : offImg
        case .text(let onText,let offText):
                titleLabel?.text = isOn ? onText : offText
            titleLabel?.textColor = isOn ? onTintColor : .placeholderText
        case .textAtt(let onText, let offText):
            titleLabel?.attributedText = isOn ? onText : offText
        default:
            break
        }
    }
}
