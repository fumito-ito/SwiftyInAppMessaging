//
//  File.swift
//
//
//  Created by Fumito Ito on 2022/08/05.
//
#if os(iOS) || os(tvOS)
    import Firebase
    import Foundation

    @testable import SwiftyInAppMessaging

    enum AlwaysNilMatchRouter: InAppMessageRouter {
        static func match(for message: InAppMessagingDisplayMessage) -> AlwaysNilMatchRouter? {
            return nil
        }

        var messageHandler: InAppMessageHandler {
            switch self {
            case .alwaysNil(let message):
                return InAppDefaultImageOnlyMessageHandler(message: message)!
            }
        }

        case alwaysNil(InAppMessagingDisplayMessage)
    }

    enum TestCustomRouter {
        case customBanner
        case customCard
        case customImageOnly
        case customModal
        case defaultBanner(InAppMessagingBannerDisplay)
        case defaultCard(InAppMessagingCardDisplay)
        case defaultImageOnly(InAppMessagingImageOnlyDisplay)
        case defaultModal(InAppMessagingModalDisplay)
    }

    extension TestCustomRouter: InAppMessageRouter {
        static func match(for message: InAppMessagingDisplayMessage) -> TestCustomRouter? {
            switch (message.type, message.campaignInfo.messageID) {
            case (.banner, "custom"):
                return .customBanner
            case (.card, "custom"):
                return .customCard
            case (.imageOnly, "custom"):
                return .customImageOnly
            case (.modal, "custom"):
                return .customModal
            case (.banner, _):
                guard let message = message as? InAppMessagingBannerDisplay else {
                    return nil
                }
                return .defaultBanner(message)
            case (.card, _):
                guard let message = message as? InAppMessagingCardDisplay else {
                    return nil
                }
                return .defaultCard(message)
            case (.imageOnly, _):
                guard let message = message as? InAppMessagingImageOnlyDisplay else {
                    return nil
                }
                return .defaultImageOnly(message)
            case (.modal, _):
                guard let message = message as? InAppMessagingModalDisplay else {
                    return nil
                }
                return .defaultModal(message)
            default:
                return nil
            }
        }

        var messageHandler: InAppMessageHandler {
            switch self {
            case .customBanner,
                .customCard,
                .customImageOnly,
                .customModal:
                return CustomInAppMessageHandler()
            case .defaultBanner(let message):
                return InAppDefaultBannerMessageHandler(message: message)
            case .defaultCard(let message):
                return InAppDefaultCardMessageHandler(message: message)
            case .defaultImageOnly(let message):
                return InAppDefaultImageOnlyMessageHandler(message: message)
            case .defaultModal(let message):
                return InAppDefaultModalMessageHandler(message: message)
            }
        }
    }
#endif
