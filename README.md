# SwiftyInAppMessaging

The easiest way to coexist your customized view and InAppMessaging default view.  

## Features

There is only one step to start using SwiftyInAppMessaging.

```swift
func application(_ application: UIApplication, didFinishLaunchWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  InAppMessaging.inAppMessaging().messageDisplayComponent = SwiftyInAppMessaging()
}
```

## Usage

### Define your message handler

```swift
struct InAppMyModalMessageHandler: InAppModalMessageHandler {
    let messageForDisplay: InAppMessagingModalDisplay

    init(message messageForDisplay: InAppMessagingModalDisplay) {
        self.messageForDisplay = messageForDisplay
    }

    func displayMessage(with delegate: InAppMessagingDisplayDelegate) throws {
        let alert = UIAlertController(title: self.messageForDisplay.title)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let messageForDisplay = self?.messageForDisplay else {
                return
            }
            
            delegate.messageClicked?(messageForDisplay, with: InAppMessagingAction(actionText: "OK", actionURL: nil)
        })

        alert.addAction(ok)

        DispatchQueue.main.async {
            UIApplication.shared.topViewController?.present(alert, animated: true, completion: nil)
        }
    }

    func displayError(_ error: Error) {
        debugLog(error)
    }
}
```

### Define your message router

```swift
enum YourOwnMessageRouter {
    case banner(InAppMessagingBannerDisplay)
    case card(InAppMessagingCardDisplay)
    case customModal(InAppMessagingModalDisplay)
    case imageOnly(InAppMessagingImageOnlyDisplay)

    static func match(for message: InAppMessagingDisplayMessage) -> Self? {
        switch message.typeWithDisplayMessage {
        case .banner(let message):
            return .banner(message: message)
        case .card(let message):
            return .card(message: message)
        case .imageOnly(let message):
            return .imageOnly(message: message)
        case .modal(let message):
            return .customModal(message: message)
        @unknown default:
            return nil
    }
    
    var messageHandler: InAppMessageHandler {
        switch self {
        case .banner(let message):
            return message.defaultHandler
        case .card(let message):
            return message.defaultHandler
        case .imageOnly(let message):
            return message.defaultHandler
        case .customModal(let message):
            return InAppMyModalMessageHandler(message: message)
        }
    }
}
```

### Pass handlers through configuration

```swift
func application(_ application: UIApplication, didFinishLaunchWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  InAppMessaging.inAppMessaging().messageDisplayComponent = SwiftyInAppMessaging<YourOwnMessageRouter>()
}
```

## Dependencies

- Firebase iOS SDK == `9.0.0`

## Installation

### Carthage

Just add your `Cartfile`

```ruby
github "fumito-ito/SwiftyInAppMessaging" ~> 1.1.1
```

and run `carthage update`

:warning: firebase ios sdk [announces to discontinue carthage support](https://github.com/firebase/firebase-ios-sdk/discussions/7129). if firebase-ios-sdk stops supporting carthage, this library will follow.

### Swift Package Manager

Just add to your `Package.swift` under dependencies

```swift
let package = Package(
    name: "MyPackage",
    products: [...],
    dependencies: [
        .package(url: "https://github.com/fumito-ito/SwiftyInAppMessaging.git", .upToNextMajor(from: "1.1.1"))
    ]
)
```

### Cocoapods

Just add to your `Podfile`

```ruby
pod 'SwiftyInAppMessaging'
```

and run `pod install`

If you have errors about `Double-quoted include "*.h" in framework header, expected angle-bracketed instead`, you can avoid these errors with following steps.

#### Recommended

1. update your cocoapods `1.10` or later
1. run `pod install` again

### If you cannot update Cocoapods

1. Click `Pods` project
1. Click Project's `Build Settings`
1. Change `Quoted include in Framework Header` to `No`

For more information, see [a firebase-ios-sdk issue](https://github.com/firebase/firebase-ios-sdk/issues/5987).

### License

SwiftyInAppMessaging is available under the Apache License 2.0. See the LICENSE file for more detail.
