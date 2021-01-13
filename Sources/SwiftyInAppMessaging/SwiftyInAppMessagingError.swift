//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/07.
//

import Foundation

public enum SwiftyInAppMessagingError: Error {
    case cardMessageWithoutPortraitImage

    public var localizedDescription: String {
        switch self {
        case .cardMessageWithoutPortraitImage:
            return "Card type message should have portrait image data"
        }
    }
}
