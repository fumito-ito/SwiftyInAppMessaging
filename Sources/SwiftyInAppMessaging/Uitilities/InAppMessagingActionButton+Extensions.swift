//
//  File.swift
//
//
//  Created by 伊藤史 on 2021/01/08.
//
#if os(iOS) || os(tvOS)
    import FirebaseInAppMessaging
    import UIKit

    public struct ActionButton {
        let buttonText: String
        let buttonTextColor: UIColor
        let buttonBackgroundColor: UIColor
    }

    extension InAppMessagingActionButton {
        public var asActionButton: ActionButton {
            return ActionButton(
                buttonText: self.buttonText,
                buttonTextColor: self.buttonTextColor,
                buttonBackgroundColor: self.buttonBackgroundColor)
        }
    }
#endif
