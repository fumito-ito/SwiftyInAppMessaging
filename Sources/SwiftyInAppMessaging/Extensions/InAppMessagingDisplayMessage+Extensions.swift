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
                    self = .unknown(message)
                    return
                }

                self = .banner(message)

            case .card:
                guard let message = message as? InAppMessagingCardDisplay else {
                    self = .unknown(message)
                    return
                }

                self = .card(message)

            case .imageOnly:
                guard let message = message as? InAppMessagingImageOnlyDisplay else {
                    self = .unknown(message)
                    return
                }

                self = .imageOnly(message)

            case .modal:
                guard let message = message as? InAppMessagingModalDisplay else {
                    self = .unknown(message)
                    return
                }

                self = .modal(message)

            @unknown default:
                self = .unknown(message)
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
