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
            switch message.type {
            case .banner:
                guard let message = message as? InAppMessagingBannerDisplay else {
                    return nil
                }
                return .banner(message: message)
            case .card:
                guard let message = message as? InAppMessagingCardDisplay else {
                    return nil
                }
                return .card(message: message)
            case .imageOnly:
                guard let message = message as? InAppMessagingImageOnlyDisplay else {
                    return nil
                }
                return .imageOnly(message: message)
            case .modal:
                guard let message = message as? InAppMessagingModalDisplay else {
                    return nil
                }
                return .modal(message: message)
            @unknown default:
                return nil
            }
        }

        public var messageHandler: InAppMessageHandler {
            switch self {
            case .banner(let message):
                return InAppDefaultBannerMessageHandler(message: message)
            case .card(let message):
                return InAppDefaultCardMessageHandler(message: message)
            case .imageOnly(let message):
                return InAppDefaultImageOnlyMessageHandler(message: message)
            case .modal(let message):
                return InAppDefaultModalMessageHandler(message: message)
            }
        }
    }
#endif
