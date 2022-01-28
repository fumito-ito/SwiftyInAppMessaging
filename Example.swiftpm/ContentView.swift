import SwiftUI
import SwiftyInAppMessaging
import FirebaseInAppMessaging

private struct Message {
    static var shared: Message = Message()
    private init() {}

    private let campaignName = "test campaign"
    private let title = "This is test campaign"
    private let body = "The future has several names. For the weak, it is impossible; for the fainthearted, it is unknown; but for the valiant, it is ideal."
    private let textColor = UIColor.black
    private let backgroundColor = UIColor.white
    private let imageData = InAppMessagingImageData(imageURL: "https://live.staticflickr.com/4676/25690386427_8c2b3eaf76_m.jpg", imageData: UIImage(named: "Cat")!.jpegData(compressionQuality: 1.0)!)
    private let actionURL = URL(string: "https://google.com")
    private let appData: [AnyHashable: Any]? = nil
    private let button = InAppMessagingActionButton(buttonText: "button",
                                                    buttonTextColor: .blue,
                                                    backgroundColor: .white)

    var banner: InAppMessagingBannerDisplay {
        return InAppMessagingBannerDisplay(campaignName: campaignName,
                                           titleText: title,
                                           bodyText: body,
                                           textColor: textColor,
                                           backgroundColor: backgroundColor,
                                           imageData: imageData,
                                           actionURL: actionURL,
                                           appData: appData)
    }

    var card: InAppMessagingCardDisplay {
        return InAppMessagingCardDisplay(campaignName: campaignName,
                                         titleText: title,
                                         bodyText: body,
                                         textColor: textColor,
                                         portraitImageData: imageData,
                                         landscapeImageData: imageData,
                                         backgroundColor: backgroundColor,
                                         primaryActionButton: button,
                                         secondaryActionButton: nil,
                                         primaryActionURL: actionURL,
                                         secondaryActionURL: nil,
                                         appData: appData)
    }

    var imageOnly: InAppMessagingImageOnlyDisplay {
        return InAppMessagingImageOnlyDisplay(campaignName: campaignName,
                                              imageData: imageData,
                                              actionURL: actionURL,
                                              appData: appData)
    }

    var modal: InAppMessagingModalDisplay {
        return InAppMessagingModalDisplay(campaignName: campaignName,
                                          titleText: title,
                                          bodyText: body,
                                          textColor: textColor,
                                          backgroundColor: backgroundColor,
                                          imageData: imageData,
                                          actionButton: button,
                                          actionURL: actionURL,
                                          appData: appData)
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 100) {
            Button("Default Banner") {
                SwiftyInAppMessaging().displayDefaultBannerMessage(for: Message.shared.banner)
            }
            Button("Default Card") {
                SwiftyInAppMessaging().displayDefaultCardMessage(for: Message.shared.card)
            }
            Button("Default Image") {
                SwiftyInAppMessaging().displayDefaultImageOnlyMessage(for: Message.shared.imageOnly)
            }
            Button("Default Modal") {
                SwiftyInAppMessaging().displayDefaultModalMessage(for: Message.shared.modal)
            }
        }
    }
}
