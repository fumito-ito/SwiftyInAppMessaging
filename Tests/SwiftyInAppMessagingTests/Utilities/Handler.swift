//
//  File.swift
//
//
//  Created by Fumito Ito on 2022/08/08.
//

#if os(iOS) || os(tvOS)
    import Foundation
    @testable import SwiftyInAppMessaging
    import Firebase

    class CustomInAppMessageHandler: InAppMessageHandler {
        var displayDelegate: InAppMessagingDisplayDelegate?

        func displayMessage(with delegate: InAppMessagingDisplayDelegate) throws {
        }

        func messageDismissed(dismissType: InAppMessagingDismissType) {
        }

        func messageClicked(with action: InAppMessagingAction) {
        }

        func impressionDetected() {
        }
    }
#endif
