//
//  SwiftyInAppMessaging.swift
//
//
//  Created by 伊藤史 on 2021/01/05.
//

#if os(iOS) || os(tvOS)
    import FirebaseInAppMessaging
    import Foundation

    public class SwiftyInAppMessaging<T: InAppMessageRouter>: InAppMessageComponent {
        public typealias Router = T

        public func displayMessage(
            _ messageForDisplay: InAppMessagingDisplayMessage,
            displayDelegate: InAppMessagingDisplayDelegate
        ) {
            DispatchQueue.main.async {
                try? Self.Router.match(for: messageForDisplay)?
                    .messageHandler
                    .displayMessage(with: displayDelegate)
            }
        }

        public init() {}
    }
#endif
