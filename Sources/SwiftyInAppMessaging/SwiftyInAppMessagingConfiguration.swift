//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import Foundation

public protocol SwiftyInAppMessagingConfiguration {
    var useDefaultHandlersIfNeeded: Bool { get }
    var messageHandlers: [InAppMessageHandler.Type] { get }
}
