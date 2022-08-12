//
//  File.swift
//
//
//  Created by 伊藤史 on 2021/01/05.
//
#if os(iOS) || os(tvOS)
    import FirebaseInAppMessaging
    import Foundation

    public protocol InAppMessageComponent: InAppMessagingDisplay {
        associatedtype Router: InAppMessageRouter
    }
#endif
