//
//  Spotboarding.swift
//  Spotboarding
//
//  Created by Alex on 06/04/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import UIKit

final class Spotboarding: UIView {
    private var overlay = UIView()
    private var maskLayer = CAShapeLayer()
    
    private var frames: [CGRect] = []
    private var currentIndex = 0
    
    init(frame: CGRect, frames: [CGRect]) {
        self.frames = frames
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userDidTap(sender:)))
        addGestureRecognizer(tap)

        maskLayer.fillRule = .evenOdd
        maskLayer.path = initialPath.cgPath

        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.isUserInteractionEnabled = true
        overlay.layer.mask = maskLayer
        addSubview(overlay)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        overlay.frame = bounds
        maskLayer.frame = bounds
    }
    
    @objc private func userDidTap(sender: UIGestureRecognizer) {
        if currentIndex == frames.count {
            return animate(to: initialPath) { [unowned self] in
                self.removeFromSuperview()
            }
        }
        let rect = frames[currentIndex]
        animate(to: maskingPath(with: rect))
        currentIndex += 1
    }
    
    func start() {
        guard let frame = frames.first else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
            self.animate(to: self.maskingPath(with: frame))
            self.currentIndex += 1
        }
    }
}

// MARK: Helpers

extension Spotboarding {
    private func animate(to path: UIBezierPath, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.25
        animation.fromValue = maskLayer.path
        animation.toValue = path.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        CATransaction.setCompletionBlock {
            completion?()
        }
        
        maskLayer.path = path.cgPath
        maskLayer.add(animation, forKey: nil)
        
        CATransaction.commit()
    }
    
    private var initialPath: UIBezierPath {
        let spacing: CGFloat = 100
        let outOfBounds = CGRect(
            x: bounds.origin.x - spacing/2, y: bounds.origin.y - spacing/2,
            width: bounds.width + spacing, height: bounds.height + spacing)
        
        return maskingPath(with: outOfBounds)
    }
    
    private func maskingPath(with rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(rect: bounds)
        let spacing: CGFloat = 12
        let cornerRadius: CGFloat = 12
        
        let irect = inflated(rect: rect, with: spacing)
        let roundedRect = UIBezierPath(roundedRect: irect, cornerRadius: cornerRadius)
        path.append(roundedRect)
        
        return path
    }
    
    private func inflated(rect: CGRect, with spacing: CGFloat) -> CGRect {
        let w = rect.width + spacing * 2
        let h = rect.height + spacing * 2
        return CGRect(x: rect.midX - w/2, y: rect.midY - h/2, width: w, height: h)
    }
}

extension UIView {
    var root: UIView? {
        UIApplication.shared.windows.first?.rootViewController?.view
    }
    
    var spotFrame: CGRect {
        guard let superview = self.superview else { fatalError() }
        return superview.convert(frame, to: root)
    }
}

extension UIBarButtonItem {
    var spotFrame: CGRect {
        guard let view = self.value(forKey: "view") as? UIView,
            let superview = view.superview else { fatalError() }
        return superview.convert(view.frame, to: view.root)
    }
}

