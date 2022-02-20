//
//  SwiftyInAppMessaging.swift
//
//
//  Created by 伊藤史 on 2021/01/05.
//

#if os(iOS) || os(tvOS)
    import FirebaseInAppMessaging
    import Foundation

    public class SwiftyInAppMessaging: InAppMessageComponent {
        public let configuration: SwiftyInAppMessagingConfiguration

        public init() {
            self.configuration = DefaultInAppMessagingConfiguration()
        }

        public init(with configuration: SwiftyInAppMessagingConfiguration) {
            self.configuration = configuration
        }
    }

    extension SwiftyInAppMessaging {
        public var messageHandlers: [InAppMessageHandler.Type] {
            if self.configuration.useDefaultHandlersIfNeeded {
                return self.configuration.messageHandlers + SwiftyInAppMessaging.defaultHandlers
            } else {
                return self.configuration.messageHandlers
            }
        }
    }

    extension SwiftyInAppMessaging {
        public func displayMessage(
            _ messageForDisplay: InAppMessagingDisplayMessage,
            displayDelegate: InAppMessagingDisplayDelegate
        ) {
            guard
                let handlerType = self.messageHandlers
                    .first(where: {
                        $0.canHandleMessage(
                            message: messageForDisplay, displayDelegate: displayDelegate)
                    })
            else {
                debugLog("there is no handler to display")
                return
            }

            DispatchQueue.main.async {
                handlerType.init(
                    message: messageForDisplay,
                    displayDelegate: displayDelegate)?
                    .displayMessage()
            }
        }
    }

    extension SwiftyInAppMessaging {
        public func displayDefaultBannerMessage(for messageForDisplay: InAppMessagingDisplayMessage)
        {
            InAppDefaultBannerMessageHandler(message: messageForDisplay)?.displayMessage()
        }

        public func displayDefaultCardMessage(for messageForDisplay: InAppMessagingDisplayMessage) {
            InAppDefaultCardMessageHandler(message: messageForDisplay)?.displayMessage()
        }

        public func displayDefaultImageOnlyMessage(
            for messageForDisplay: InAppMessagingDisplayMessage
        ) {
            InAppDefaultImageOnlyMessageHandler(message: messageForDisplay)?.displayMessage()
        }

        public func displayDefaultModalMessage(for messageForDisplay: InAppMessagingDisplayMessage)
        {
            InAppDefaultModalMessageHandler(message: messageForDisplay)?.displayMessage()
        }
    }
#endif
