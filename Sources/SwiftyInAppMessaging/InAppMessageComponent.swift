//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import Foundation
import Firebase

public protocol InAppMessageComponent: InAppMessagingDisplay {
    var configuration: SwiftyInAppMessagingConfiguration { get }

    static var defaultHandlers: [InAppMessageHandler.Type] { get }

    var messageHandlers: [InAppMessageHandler.Type] { get }
}

extension InAppMessageComponent {
    public static var defaultHandlers: [InAppMessageHandler.Type] {
        return [
            InAppDefaultModalMessageHandler.self,
            InAppDefaultImageOnlyMessageHandler.self,
            InAppDefaultCardMessageHandler.self,
            InAppDefaultBannerMessageHandler.self
        ]
    }
}
