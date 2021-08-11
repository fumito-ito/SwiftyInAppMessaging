//
//  UIViewController+Extensions.swift
//  SwiftyInAppMessaging
//
//  Created by 伊藤史 on 2021/03/21.
//

import Foundation
import UIKit

extension UIViewController {
    func dismissView() {
        self.view.window?.isHidden = true
        self.view.window?.rootViewController = nil
    }
}
