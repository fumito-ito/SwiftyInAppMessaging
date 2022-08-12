//
//  File.swift
//
//
//  Created by Fumito Ito on 2022/08/05.
//
#if os(iOS) || os(tvOS)
    import Firebase
    import Foundation

    internal func getDisplayMessage(
        messageID: String = "",
        campaignName: String = "",
        renderAsTestMessage: Bool = false,
        messageType: FIRInAppMessagingDisplayMessageType,
        triggerType: FIRInAppMessagingDisplayTriggerType = .onAppForeground
    ) -> InAppMessagingDisplayMessage {
        switch messageType {
        case .modal:
            return InAppMessagingModalDisplay(
                messageID: messageID,
                campaignName: campaignName,
                renderAsTestMessage: renderAsTestMessage,
                messageType: messageType,
                triggerType: triggerType
            )
        case .banner:
            return InAppMessagingBannerDisplay(
                messageID: messageID,
                campaignName: campaignName,
                renderAsTestMessage: renderAsTestMessage,
                messageType: messageType,
                triggerType: triggerType
            )
        case .imageOnly:
            return InAppMessagingImageOnlyDisplay(
                messageID: messageID,
                campaignName: campaignName,
                renderAsTestMessage: renderAsTestMessage,
                messageType: messageType,
                triggerType: triggerType
            )
        case .card:
            return InAppMessagingCardDisplay(
                messageID: messageID,
                campaignName: campaignName,
                renderAsTestMessage: renderAsTestMessage,
                messageType: messageType,
                triggerType: triggerType
            )
        @unknown default:
            return InAppMessagingDisplayMessage(
                messageID: messageID,
                campaignName: campaignName,
                renderAsTestMessage: renderAsTestMessage,
                messageType: messageType,
                triggerType: triggerType
            )
        }
    }
#endif
