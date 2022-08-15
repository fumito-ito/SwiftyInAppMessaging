//
//  File.swift
//
//
//  Created by 伊藤史 on 2021/01/05.
//
#if os(iOS) || os(tvOS)
    import Foundation
    import FirebaseInAppMessaging

    public enum DefaultInAppMessagingRouter {
        case banner(message: InAppMessagingBannerDisplay)
        case card(message: InAppMessagingCardDisplay)
        case imageOnly(message: InAppMessagingImageOnlyDisplay)
        case modal(message: InAppMessagingModalDisplay)
    }

    extension DefaultInAppMessagingRouter: InAppMessageRouter {
        public static func match(for message: InAppMessagingDisplayMessage)
            -> DefaultInAppMessagingRouter?
        {
            switch message.typeWithDisplayMessage {
            case .banner(let message):
                return .banner(message: message)
            case .card(let message):
                return .card(message: message)
            case .imageOnly(let message):
                return .imageOnly(message: message)
            case .modal(let message):
                return .modal(message: message)
            case .unknown:
                return nil
            }
        }

        public var messageHandler: InAppMessageHandler {
            switch self {
            case .banner(let message):
                return message.defaultHandler
            case .card(let message):
                return message.defaultHandler
            case .imageOnly(let message):
                return message.defaultHandler
            case .modal(let message):
                return message.defaultHandler
            }
        }
    }
#endif
