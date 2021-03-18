//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import Foundation
import UIKit

extension UIApplication {
    static var rootViewController: UIViewController? {
        guard var rootViewController = UIApplication.rootWindow?.rootViewController else {
            return nil
        }

        while let presentedViewController = rootViewController.presentedViewController {
            rootViewController = presentedViewController
        }

        return rootViewController
    }

    static var rootWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.foregroundScene?.windows.first ?? UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
        }

        return UIApplication.shared.delegate?.window ?? nil
    }

    static var windowForMessage: UIWindow? {
        if #available(iOS 13.0, *) {
            guard let scene = UIApplication.foregroundScene else {
                return nil
            }

            let window = UIWindow(windowScene: scene)
            window.windowLevel = .normal

            return window
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.windowLevel = .normal

            return window
        }
    }

    static var windowForBanner: UIWindow? {
        if #available(iOS 13.0, *) {
            guard let scene = UIApplication.foregroundScene else {
                return nil
            }

            let window = UIWindowForBanner(windowScene: scene)
            window.windowLevel = .normal

            return window
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.windowLevel = .normal

            return window
        }
    }

    @available(iOS 13.0, *)
    static var foregroundScene: UIWindowScene? {
        guard let scene = UIApplication.shared
                .connectedScenes
                .first(where: { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }) else {
            return nil
        }

        return scene as? UIWindowScene
    }
}

final class UIWindowForBanner: UIWindow {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let viewController = self.rootViewController,
           viewController.view != nil else {
            return false
        }

        return viewController.view.frame.contains(point)
    }
}
