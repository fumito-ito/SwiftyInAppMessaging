//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import Foundation
import UIKit

extension UIApplication {
    var topViewController: UIViewController? {
        guard var topViewController = self.delegate?.window??.rootViewController else {
            return nil
        }

        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }

        return topViewController
    }
}
