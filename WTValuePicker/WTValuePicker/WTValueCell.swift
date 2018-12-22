//
//  WTValueCell.swift
//  WTValuePicker
//
//  Created by Sergey Chehuta on 23/12/2018.
//  Copyright © 2018 WhiteTown. All rights reserved.
//

import UIKit

class WTValueCell: UITableViewCell {

    var fillColor   = UIColor.white {
        didSet {
            self.valueLabel.fillColor = self.fillColor
        }
    }

    var attributes: [NSAttributedString.Key : Any]? = nil {
        didSet {
            setAttributedText()
        }
    }

    private let valueLabel = WTLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.valueLabel.frame = self.contentView.bounds
    }

    private func initialize() {

        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.valueLabel)
    }

    private func setAttributedText() {
        self.valueLabel.attributedText = NSAttributedString(string:self.valueLabel.text ?? "",
                                                            attributes: self.attributes)
    }

    func setText(_ text: String?) {
        self.valueLabel.text = text
        setAttributedText()
    }

    class func cellIndenfier() -> String {
        return NSStringFromClass(WTValueCell.self)
    }

}
