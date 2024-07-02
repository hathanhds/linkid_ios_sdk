//
//  UINavigationBar.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 27/02/2024.
//

import UIKit

extension UINavigationBar {
    func setGradientBackground(colors: [CGColor], titleColor: UIColor = .white) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.locations = [0.0, 1.0] // Start and end points

        var updatedFrame = self.bounds
//        updatedFrame.size.height += self.frame.origin.y
        gradient.frame = updatedFrame
        gradient.colors = colors;
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        let image = self.image(fromLayer: gradient)
        appearance.backgroundImage = image
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
    }

    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
}
