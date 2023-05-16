//
//  TextViewController.swift
//  MikCore
//
//  Created by gaowei on 2021/4/21.
//

import UIKit
import SnapKit

class TextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let textView = MikTextViewCell()
        textView.title = "First Name"
        textView.message = "0 / 50 characters"
        textView.isNext = false
        textView.placeholder = "name"
        textView.isHiddenLeftButton = true
        textView.isHiddenRightButton = true
        textView.isHiddenFullButton = true
        textView.defaultTextViewHeight = 50.rate
        textView.maxTextViewHeight = 100.rate
        textView.autocapitalizationType = .words
        textView.text = "michaels"
        textView.maxInputWords = 50
        textView.textFont = UIFont.mik.font(.nunitoSans, size: 36.rate)
        textView.disableInputs = [ ",", "!" ]
        textView.placeholderFont = UIFont.mik.font(size: 12.rate)
        textView.autocapitalizationType = .sentences
        self.view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(40.rate)
            make.top.equalToSuperview().inset(120.0)
        }
//        textView.text = "mmmmmmmmm"
        
        let textView1 = MikTextViewCell()
        textView1.title = "First Name"
        textView1.message = "0 / 50 characters"
        textView1.placeholder = "The BOPIS and SDD messaging on the mobile app PDPs are different than what’s displayed on mobile web."
        textView1.isHiddenLeftButton = false
        textView1.isHiddenFullButton = true
        textView1.leftImage = UIImage(named: "tabbar_dash_n")
        textView1.rightImage = UIImage(named: "tabbar_dash_s")
        textView1.defaultTextViewHeight = 100.rate
        self.view.addSubview(textView1)
        textView1.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(40.rate)
            make.top.equalTo(textView.snp.bottom).offset(50.0)
        }
        
        let textField = MikNumberTextView()
        textField.title = "please input number"
        textField.isInputPrice = true
//        textField.minNumber = "1.0"
//        textField.maxNumber = "1000.00"
//        textField.maxInputWords = 4
        textField.text = "199999999".asCurrencyNumber()
        textField.message = "The maximum input is 1000"
        self.view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(40.rate)
            make.top.equalTo(textView1.snp.bottom).offset(50.0)
        }
        
        let successTextView = MikTextViewCell()
        successTextView.title = "First Name"
        successTextView.setMessage("wrong", style: .success)
        successTextView.placeholder = "name"
//        textView.textBackgroundColor = UIColor.red
        successTextView.isHiddenLeftButton = false
        successTextView.leftImage = UIImage(named: "tabbar_dash_n")
        successTextView.isHiddenFullButton = true
//        textView.maxInputWords = 20
        self.view.addSubview(successTextView)
        successTextView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(40.rate)
            make.top.equalTo(textField.snp.bottom).offset(50.0)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
