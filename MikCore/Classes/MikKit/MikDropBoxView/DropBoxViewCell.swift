//
//  DropBoxViewCell.swift
//  MikCore
//
//  Created by gaowei on 2021/4/26.
//

import UIKit
import SnapKit


class DropBoxViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    lazy var titleLabel: UILabel = {
        let item = UILabel()
        item.font = UIFont.mik.font(size: 14.rate)
        item.textColor = UIColor.mik.text(.hex000000)
        
        return item
    }()
    
    lazy var selectedButton: UIButton = {
        let item = UIButton()
        item.setImage(UIImage.image("drop_box_n"), for: .normal)
        item.setImage(UIImage.image("drop_box_s"), for: .selected)
        item.isUserInteractionEnabled = false
        
        return item
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(24.rate)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(self.selectedButton)
        self.selectedButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(24.rate)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DropBoxViewCell {
    func setModel(_ model: DropBoxModel) {
        self.titleLabel.text = model.title
        self.selectedButton.isSelected = model.isSelected
        
        self.selectedButton.isHidden = model.isHiddenSelected
        self.titleLabel.font = model.titleFont
        self.titleLabel.textColor = model.titleColor
    }
}
