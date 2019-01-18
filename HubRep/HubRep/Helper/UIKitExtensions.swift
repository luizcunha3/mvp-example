//
//  UIKitExtensions.swift
//  HubRep
//
//  Created by Tomaz Correa da Silva on 27/11/18.
//  Copyright © 2018 hubrep. All rights reserved.
//

import UIKit

// MARK: - UIVIEW -
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    func startShimmering() {
        let gradient = self.getShimmerGradient()
        self.layer.mask = gradient
        let animation = self.getShimmerAnimation()
        gradient.add(animation, forKey: "shimmer")
    }
    
    private func getShimmerGradient() -> CAGradientLayer {
        let light = UIColor.gray.withAlphaComponent(0.9).cgColor
        let alpha = UIColor.gray.withAlphaComponent(0.7).cgColor
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha]
        gradient.frame = CGRect(x: -width, y: 0, width: 3 * width, height: height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]
        return gradient
    }
    
    private func getShimmerAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1
        animation.repeatCount = HUGE
        return animation
    }
    
    func stopShimmering() {
        self.layer.mask = nil
    }
}

// MARK: - UICOLOR -
extension UIColor {
    convenience init(colorHex: Int, alpha: CGFloat = 1.0) {
        self.init(red: (colorHex >> 16) & 0xff, green: (colorHex >> 8) & 0xff, blue: colorHex & 0xff, alpha: alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}

// MARK: - UINAVIGATIONCONTROLLER -
extension UINavigationController {
    func navigationBarCustomize() {
        let gradient = CAGradientLayer()
        var bounds = navigationBar.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [Constants.Colors.primaryColor.cgColor, Constants.Colors.secondaryColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        if let image = self.getImageFrom(gradientLayer: gradient) {
            navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        }
        navigationBar.shadowImage = UIImage()
    }
    
    private func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}
