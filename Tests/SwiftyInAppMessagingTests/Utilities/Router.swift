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
#endif
