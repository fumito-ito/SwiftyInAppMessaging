//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//
#if os(iOS) || os(tvOS)
import Foundation

public struct DefaultInAppMessagingConfiguration: SwiftyInAppMessagingConfiguration {
    public let useDefaultHandlersIfNeeded: Bool

    public let messageHandlers: [InAppMessageHandler.Type]

    public init() {
        self.useDefaultHandlersIfNeeded = true
        self.messageHandlers = []
    }
}
#endif
