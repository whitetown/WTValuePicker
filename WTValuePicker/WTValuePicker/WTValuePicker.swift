//
//  WTValuePicker.swift
//  WTValuePicker
//
//  Created by Sergey Chehuta on 22/12/2018.
//  Copyright © 2018 WhiteTown. All rights reserved.
//

import UIKit

open class WTValuePicker: UIView {

    public var fillColor   = UIColor.white {
        didSet {
            updateForegroundColor()
            self.tableView.reloadData()
        }
    }

    public var normalColor   = UIColor.black {
        didSet {
            updateBgView()
        }
    }

    public var selectedColor = UIColor.orange {
        didSet {
            updateBgView()
        }
    }

    public var cellHeight: CGFloat = 44.0 {
        didSet {
            updateBgView()
            setNeedsLayout()
            setNeedsDisplay()
            self.tableView.reloadData()
        }
    }

    public var attributes: [NSAttributedString.Key : Any]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    public var minValue: Int = 0
    public var maxValue: Int = 20

    public var onSelect:    ((_ value: Int)->Void)?
    public var onScrolling: ((_ isScrolling: Bool)->Void)?

    public private (set) var isScrolling = false
    public private (set) var value: Int = 0

    private let bgView    = WTBandView()
    private let tableView = UITableView()

    private let tableTop    = UIView()
    private let tableBottom = UIView()

    private let additionalTop    = UIView()
    private let additionalBottom = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {

        updateBgView()
        updateForegroundColor()

        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(WTValueCell.self, forCellReuseIdentifier: WTValueCell.cellIndenfier())

        self.tableView.backgroundView = self.bgView
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false

        self.tableTop.addSubview(self.additionalTop)
        self.tableBottom.addSubview(self.additionalBottom)

        self.addSubview(self.tableView)
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()

        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear

        setHeaderFooter()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        self.tableView.frame = self.bounds
        setHeaderFooter()
    }

    private func setHeaderFooter() {

        self.tableTop.frame = CGRect(x: 0, y: 0,
                                     width: self.tableView.frame.size.width,
                                     height: self.frame.size.height / 2 - self.cellHeight / 2)
        self.tableBottom.frame = CGRect(x: 0, y: 0,
                                        width: self.tableView.frame.size.width,
                                        height: self.frame.size.height / 2 - self.cellHeight / 2)

        self.additionalTop.frame = CGRect(x: 0,
                                          y: -self.tableTop.frame.size.height,
                                          width: self.tableTop.frame.size.width,
                                          height: self.tableTop.frame.size.height)

        self.additionalBottom.frame = CGRect(x: 0,
                                          y: self.tableBottom.frame.size.height,
                                          width: self.tableBottom.frame.size.width,
                                          height: self.tableBottom.frame.size.height)

        self.tableView.tableHeaderView = self.tableTop
        self.tableView.tableFooterView = self.tableBottom
    }

    private func updateForegroundColor() {
        self.tableTop.backgroundColor = self.fillColor
        self.tableBottom.backgroundColor = self.fillColor
        self.additionalTop.backgroundColor = self.fillColor
        self.additionalBottom.backgroundColor = self.fillColor
    }

    private func updateBgView() {
        self.bgView.backgroundColor = self.normalColor
        self.bgView.bandColor  = self.selectedColor
        self.bgView.bandHeight = self.cellHeight
    }

    private func setRow(_ row: Int, animated: Bool = true) {
        setValue(row, animated: animated)
        self.onSelect?(row)
    }

    public func setValue(_ value: Int, animated: Bool = true) {
        let safeValue = min(max(self.minValue, value), self.maxValue)
        self.tableView.scrollToRow(at: IndexPath(row: safeValue, section: 0), at: .middle, animated: true)
        self.value = value
    }

}

extension WTValuePicker: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.maxValue - self.minValue + 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: WTValueCell.cellIndenfier(), for: indexPath) as! WTValueCell
        cell.fillColor  = self.fillColor
        cell.attributes = self.attributes
        cell.setText( "\(indexPath.row + self.minValue)" )
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        setRow(indexPath.row)
    }

}

extension WTValuePicker: UIScrollViewDelegate {

    private func setNearestRow() {
        let row: Int = Int((self.tableView.contentOffset.y + self.cellHeight/2) / self.cellHeight)
        setRow(row)
        self.isScrolling = false
        self.onScrolling?(self.isScrolling)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrolling = true
        self.onScrolling?(self.isScrolling)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            setNearestRow()
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setNearestRow()
    }

}

class WTBandView: UIView {

    var bandColor:  UIColor = .orange
    var bandHeight: CGFloat = 44

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .black
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setFillColor(self.bandColor.cgColor)

        let rectangle = CGRect(x: 0,
                               y: self.frame.size.height/2 - self.bandHeight/2,
                               width: self.frame.size.width,
                               height: self.bandHeight)

        context.fill(rectangle)
    }
}
