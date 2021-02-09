//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import Foundation
import FirebaseInAppMessaging
import UIKit

struct InAppDefaultImageOnlyMessageHandler: InAppImageOnlyMessageHandler {
    let messageForDisplay: InAppMessagingImageOnlyDisplay
    weak var displayDelegate: InAppMessagingDisplayDelegate?

    init?(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) {
        guard let messageForDisplay = messageForDisplay as? InAppMessagingImageOnlyDisplay else {
            return nil
        }

        self.messageForDisplay = messageForDisplay
        self.displayDelegate = displayDelegate
    }

    static func canHandleMessage(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) -> Bool {
        return messageForDisplay is InAppMessagingImageOnlyDisplay
    }

    func displayMessage() {
        do {
            let image = try UIImage(imageData: self.messageForDisplay.imageData)
            let viewController = InAppDefaultImageOnlyMessageViewController(image: image,
                                                                            actionURL: self.messageForDisplay.actionURL,
                                                                            eventDetector: self)

            DispatchQueue.main.async {
                UIApplication.shared.topViewController?.present(viewController, animated: true, completion: nil)
            }
        } catch let error {
            self.displayError(error)
        }
    }

    func displayError(_ error: Error) {
        debugLog(error)
    }
}
