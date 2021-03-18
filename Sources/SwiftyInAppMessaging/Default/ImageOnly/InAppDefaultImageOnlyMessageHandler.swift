//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import Firebase
import Foundation
import UIKit

struct InAppDefaultImageOnlyMessageHandler: InAppImageOnlyMessageHandler {
    let messageForDisplay: InAppMessagingImageOnlyDisplay
    weak var displayDelegate: InAppMessagingDisplayDelegate?

    private static var window: UIWindow?

    init?(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) {
        guard let messageForDisplay = messageForDisplay as? InAppMessagingImageOnlyDisplay else {
            return nil
        }

        self.messageForDisplay = messageForDisplay
        self.displayDelegate = displayDelegate
    }

    static func canHandleMessage(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) -> Bool {
        return messageForDisplay.type == .imageOnly
    }

    func displayMessage() {
        do {
            let image = try UIImage(imageData: self.messageForDisplay.imageData)
            let viewController = InAppDefaultImageOnlyMessageViewController(image: image,
                                                                            actionURL: self.messageForDisplay.actionURL,
                                                                            eventDetector: self)

            InAppDefaultImageOnlyMessageHandler.window = UIApplication.windowForMessage
            InAppDefaultImageOnlyMessageHandler.window?.rootViewController = viewController
            InAppDefaultImageOnlyMessageHandler.window?.isHidden = false
        } catch let error {
            self.displayError(error)
        }
    }

    func displayError(_ error: Error) {
        debugLog(error)
    }
}
