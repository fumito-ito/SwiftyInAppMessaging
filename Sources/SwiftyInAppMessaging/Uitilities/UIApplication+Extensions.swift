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
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        var topViewController: UIViewController = rootViewController

            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }

            return topViewController
        } else {
            return nil
        }
    }
}
