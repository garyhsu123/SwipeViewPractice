//
//  SwipeViewCell.swift
//  Practice
//
//  Created by Yu-Chun Hsu on 2022/11/15.
//

import Foundation
import UIKit

protocol SwipeViewCellDelegate: AnyObject {
    func didSwipeLeft()
    func didSwifeRight()
}

class SwipeViewCell: UICollectionViewCell {
    
    var panGesture: UIPanGestureRecognizer?
    var rotationCenter: CGPoint!
    var previousLocation: CGPoint?
    
    var delegate: SwipeViewCellDelegate?
    let threshold = 50.0
    
    @IBOutlet weak var customView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanCustomView(_:)))
    }
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        rotationCenter = CGPoint(x: self.center.x, y: self.bounds.maxY)
    }
    
    func setup() {
        self.previousLocation = nil
        self.customView.transform = .identity
        if self.customView.gestureRecognizers == nil, let panGesture = self.panGesture {
            self.customView.addGestureRecognizer(panGesture)
        }
    }
    
    
    @objc func didPanCustomView(_ sender: UIPanGestureRecognizer) {
        if (sender.state == .ended) {
            let transformCenter = customView.center.applying(customView.transform)
            if transformCenter.x < self.bounds.minX + threshold {
                self.delegate?.didSwipeLeft()
            }
            else if transformCenter.x > self.bounds.maxX - threshold {
                self.delegate?.didSwifeRight()
            }
            else {
                self.previousLocation = nil
                self.customView.transform = .identity
            }
        }
        else {
            let currentLocation = sender.location(in: self)
            guard let previousLocation = self.previousLocation else {
                previousLocation = currentLocation
                return
            }
            
            let offsetX = currentLocation.x - previousLocation.x
            let offsetY = currentLocation.y - previousLocation.y

            var transform: CGAffineTransform = self.customView.transform
            
            transform = CGAffineTransformTranslate(transform, self.customView.transform.tx + offsetX, self.bounds.maxY)
            transform = CGAffineTransformRotate(transform, Double.pi * (offsetX * 0.1) / self.bounds.midX)
            transform = CGAffineTransformTranslate(transform, -self.customView.transform.tx - offsetX, -self.bounds.maxY)
            transform = CGAffineTransformTranslate(transform, offsetX, offsetY)
            
            self.customView.transform = transform
            
            
            self.previousLocation = currentLocation
        }
    }
   
}
