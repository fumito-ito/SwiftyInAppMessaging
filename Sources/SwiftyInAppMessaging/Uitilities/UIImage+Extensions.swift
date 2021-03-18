//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import Firebase
import Foundation

extension UIImage {
    public convenience init?(imageData: InAppMessagingImageData?) throws {
        guard let imageData = imageData else {
            return nil
        }

        if let imageRawData = imageData.imageRawData {
            self.init(data: imageRawData)
        }

        guard let url = URL(string: imageData.imageURL) else {
            return nil
        }

        let data = try Data(contentsOf: url)
        self.init(data: data)
    }

    static func image(with color: UIColor, rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
