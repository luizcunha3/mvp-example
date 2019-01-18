//
//  GradientView.swift
//  HubRep
//
//  Created by Tomaz Correa da Silva on 27/11/18.
//  Copyright © 2018 hubrep. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    @IBInspectable public var topColor: UIColor = Constants.Colors.primaryColor {
        didSet {
            self.setupGradient()
        }
    }
    
    @IBInspectable public var bottomColor: UIColor = Constants.Colors.secondaryColor {
        didSet {
            self.setupGradient()
        }
    }
    
    private var gradientLayer: CAGradientLayer!
}

extension GradientView {
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setupGradient()
    }
    
    func setupGradient() {
        if let existingLayer = self.gradientLayer {
            existingLayer.removeFromSuperlayer()
        }
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.colors = [self.topColor.cgColor, self.bottomColor.cgColor]
        self.gradientLayer.frame = self.bounds
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        UIGraphicsBeginImageContext(self.gradientLayer.bounds.size)
        self.gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        self.layer.insertSublayer(self.gradientLayer, at: 0)
    }
}
