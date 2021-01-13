//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import Foundation
import UIKit

extension UIColor {
    func image() -> UIImage? {
        return self.image(size: CGSize(width: 1, height: 1))
    }

    func image(size: CGSize) -> UIImage? {
        return UIImage.image(with: self, rect: CGRect(origin: CGPoint.zero, size: size))
    }
}
