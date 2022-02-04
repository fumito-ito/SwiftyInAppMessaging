//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

#if os(iOS) || os(tvOS)
import Foundation
import UIKit

extension UIApplication {
    static var rootWindow: UIWindow? {
        if #available(iOS 13.0, tvOS 13.0, *) {
            return UIApplication.foregroundScene?.windows.first ?? UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
        }

        return UIApplication.shared.delegate?.window ?? nil
    }

    static var windowForMessage: UIWindow? {
        if #available(iOS 13.0, tvOS 13.0, *) {
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
        if #available(iOS 13.0, tvOS 13.0, *) {
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

    @available(iOS 13.0, tvOS 13.0, *)
    static var foregroundScene: UIWindowScene? {
        guard let scene = UIApplication.shared
                .connectedScenes
                .first(where: { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }) else {
            return nil
        }

        return scene as? UIWindowScene
    }

    static var interfaceOrientation: UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .unknown
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }


}

final class UIWindowForBanner: UIWindow {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let viewController = self.rootViewController as? InAppDefaultBannerMessageViewController,
              viewController.view != nil else {
            return false
        }

        return viewController.bannerView.frame.contains(point)
    }
}
#endif
