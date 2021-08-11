//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/08.
//

// swiftlint:disable unused_import
import Firebase
// swiftlint:enable unused_import
import Foundation

public struct ActionButton {
    let buttonText: String
    let buttonTextColor: UIColor
    let buttonBackgroundColor: UIColor
}

extension InAppMessagingActionButton {
    public var asActionButton: ActionButton {
        return ActionButton(buttonText: self.buttonText,
                            buttonTextColor: self.buttonTextColor,
                            buttonBackgroundColor: self.buttonBackgroundColor)
    }
}
