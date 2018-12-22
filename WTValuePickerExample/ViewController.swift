//
//  ViewController.swift
//  WTValuePickerExample
//
//  Created by Sergey Chehuta on 22/12/2018.
//  Copyright © 2018 WhiteTown. All rights reserved.
//

import UIKit
import WTValuePicker

class ViewController: UIViewController {

    let picker1 = WTValuePicker()
    let picker2 = WTValuePicker()

    let button = UIButton()
    let line = WTTouchlessView()

    override func viewDidLoad() {
        super.viewDidLoad()

        weak var welf = self

        self.picker1.fillColor = .yellow
        self.picker2.fillColor = .yellow

        self.picker1.attributes = [
             NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32)
            ]

        self.picker2.attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .light)
        ]


        self.picker1.frame = CGRect(x: 0, y: 0, width: 100, height: self.view.frame.size.height)
        self.view.addSubview(self.picker1)

        self.picker2.frame = CGRect(x: self.view.frame.size.width-100, y: 0, width: 100, height: self.view.frame.size.height)
        self.view.addSubview(self.picker2)

        self.picker1.onSelect = { value in
            print("onSelect picker1", value, self.picker1.value, self.picker1.isScrolling)
        }
        self.picker1.onScrolling = { isScrolling in
            print("onScrolling picker1", isScrolling, self.picker1.isScrolling)
            welf?.handleOnScroll()
        }

        self.picker2.onSelect = { value in
            print("onSelect picker2", value, self.picker2.value, self.picker2.isScrolling)
        }
        self.picker2.onScrolling = { isScrolling in
            print("onScrolling picker2", isScrolling, self.picker2.isScrolling)
            welf?.handleOnScroll()
        }

        self.button.frame = CGRect(x: 100, y: self.view.frame.size.height-100, width: self.view.frame.size.width-200, height: 50)
        self.button.backgroundColor = .orange
        self.button.setTitle("Reset", for: .normal)
        self.button.addTarget(self, action: #selector(btnTap), for: .touchUpInside)
        self.view.addSubview(self.button)

        self.line.layer.borderWidth = 0.5
        self.line.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
        self.line.frame = CGRect(x: -1, y: self.picker1.center.y - self.picker1.cellHeight/2, width: self.view.frame.size.width+2, height: self.picker1.cellHeight)
        self.view.addSubview(self.line)

    }

    func handleOnScroll() {
        self.button.isEnabled = !self.picker1.isScrolling && !self.picker2.isScrolling
    }

    @objc func btnTap() {
        self.picker1.setValue(0)
        self.picker2.setValue(20)
    }


}

class WTTouchlessView: UIView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}
