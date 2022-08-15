//
//  File.swift
//  
//
//  Created by Fumito Ito on 2022/08/15.
//

#if os(iOS) || os(tvOS)
import FirebaseInAppMessaging

public enum InAppMessagingDisplayMessageTypeWithMessage {
    case banner(InAppMessagingBannerDisplay)
    case card(InAppMessagingCardDisplay)
    case imageOnly(InAppMessagingImageOnlyDisplay)
    case modal(InAppMessagingModalDisplay)
    case unknown(InAppMessagingDisplayMessage)

    init(message: InAppMessagingDisplayMessage) {
        switch message.type {
        case .banner:
            guard let message = message as? InAppMessagingBannerDisplay else {
                return unknown(message)
            }

            self = .banner(message)

        case .card:
            guard let message = message as? InAppMessagingCardDisplay else {
                return unknown(message)
            }

            self = .card(message)

        case .imageOnly:
            guard let message = message as? InAppMessagingImageOnlyDisplay else {
                return unknown(message)
            }

            self = .imageOnly(message)

        case .modal:
            guard let message = message as? InAppMessagingModalDisplay else {
                return unknown(message)
            }

            self = .modal(message)
        }
    }
}

extension InAppMessagingDisplayMessage {
    public var typeWithDisplayMessage: InAppMessagingDisplayMessageTypeWithMessage {
        return InAppMessagingDisplayMessageTypeWithMessage(message: self)
    }
}

extension InAppMessagingBannerDisplay {
    public var defaultHandler: InAppMessageHandler {
        return InAppDefaultBannerMessageHandler(message: self)
    }
}

extension InAppMessagingCardDisplay {
    public var defaultHandler: InAppMessageHandler {
        return InAppDefaultCardMessageHandler(message: self)
    }
}

extension InAppMessagingImageOnlyDisplay {
    public var defaultHandler: InAppMessageHandler {
        return InAppDefaultImageOnlyMessageHandler(message: self)
    }
}

extension InAppMessagingModalDisplay {
    public var defaultHandler: InAppMessageHandler {
        return InAppDefaultModalMessageHandler(message: self)
    }
}
#endif
