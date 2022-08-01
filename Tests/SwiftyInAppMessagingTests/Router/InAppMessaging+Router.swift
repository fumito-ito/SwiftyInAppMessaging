//
//  InAppMessaging+Router.swift
//
//
//  Created by Fumito Ito on 2022/08/04.
//
#if os(iOS) || os(tvOS)
    import Firebase
    import XCTest

    @testable import SwiftyInAppMessaging
    class InAppMessagingRouterTest: XCTestCase {
        func testAlwaysNilRouterReturnsNil() {
            let message = getDisplayMessage(messageType: .modal)
            XCTAssertNil(AlwaysNilMatchRouter.match(for: message))
        }

        func testDefaultRouterReturnsMessageHandlerAlongWithMessageType() {
            let modal = getDisplayMessage(messageType: .modal)
            let modalHandler = DefaultInAppMessagingRouter.match(for: modal)?.messageHandler
            XCTAssert(modalHandler is InAppDefaultModalMessageHandler)
            XCTAssert(modalHandler is InAppModalMessageHandler)

            let banner = getDisplayMessage(messageType: .banner)
            let bannerHandler = DefaultInAppMessagingRouter.match(for: banner)?.messageHandler
            XCTAssert(bannerHandler is InAppDefaultBannerMessageHandler)
            XCTAssert(bannerHandler is InAppBannerMessageHandler)

            let card = getDisplayMessage(messageType: .card)
            let cardHandler = DefaultInAppMessagingRouter.match(for: card)?.messageHandler
            XCTAssert(cardHandler is InAppDefaultCardMessageHandler)
            XCTAssert(cardHandler is InAppCardMessageHandler)

            let imageOnly = getDisplayMessage(messageType: .imageOnly)
            let imageOnlyHandler = DefaultInAppMessagingRouter.match(for: imageOnly)?.messageHandler
            XCTAssert(imageOnlyHandler is InAppDefaultImageOnlyMessageHandler)
            XCTAssert(imageOnlyHandler is InAppImageOnlyMessageHandler)
        }
    }
#endif
