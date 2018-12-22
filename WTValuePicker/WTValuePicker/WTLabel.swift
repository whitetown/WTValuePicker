//
//  WTLabel.swift
//  WTValuePicker
//
//  Created by Sergey Chehuta on 23/12/2018.
//  Copyright © 2018 WhiteTown. All rights reserved.
//

import UIKit

class WTLabel: UILabel {

    open var fillColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }

    public init() {
        super.init(frame: CGRect.zero)
        initialize()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 36)
    }

    override open func drawText(in rect: CGRect) {

        super.drawText(in: rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }
        defer { context.restoreGState() }

        if let mask = context.mask() {

            context.saveGState()
            context.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: rect.height))

            context.clear(rect)
            context.clip(to: rect, mask: mask)

            context.fill(rect, with: self.fillColor)
        }
    }

    
}

internal extension CGContext {

    func mask() -> CGImage? {

        guard let image = makeImage() else { return nil }

        if let imageMask = imageMask(from: image) {
            return imageMask
        } else {
            return image
        }
    }

    func fill(_ rect: CGRect, with color: UIColor) {
        setFillColor(color.cgColor)
        fill(CGRect(x: 0.0, y: 0.0, width: rect.width, height: rect.height))
    }

    func imageMask(from image:CGImage) -> CGImage? {

        guard
            let dataProvider = image.dataProvider,
            let imageMask = CGImage(maskWidth: image.width,
                                    height: image.height,
                                    bitsPerComponent: image.bitsPerComponent,
                                    bitsPerPixel: image.bitsPerPixel,
                                    bytesPerRow: image.bytesPerRow,
                                    provider: dataProvider,
                                    decode: image.decode,
                                    shouldInterpolate: true) else {
                                        return nil
        }
        return imageMask
    }
}
