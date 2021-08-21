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
    let displayDelegate: InAppMessagingDisplayDelegate

    init?(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) {
        guard let messageForDisplay = messageForDisplay as? InAppMessagingModalDisplay else {
            return nil
        }

        self.messageForDisplay = messageForDisplay
        self.displayDelegate = displayDelegate
    }

    static func canHandleMessage(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) -> Bool {
        return messageForDisplay is InAppMessagingModalDisplay
    }

    func displayMessage() {
        let alert = UIAlertController(title: self.messageForDisplay.title)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in })

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

### Define your configuration

```swift
struct MyInAppMessagingConfiguration: SwiftyInAppMessagingConfiguration {
    let useDefaultHandlersIfNeeded: Bool = true
    let messageHandlers: [InAppMessageHandler.Type] = [
        InAppMyModalMessageHandler.self
    ]
}
```

### Pass handlers through configuration

```swift
func application(_ application: UIApplication, didFinishLaunchWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  let config = MyInAppMessagingConfiguration()
  InAppMessaging.inAppMessaging().messageDisplayComponent = SwiftyInAppMessaging(with: config)
}
```

## Dependencies

- Firebase iOS SDK == `8.4.0`

## Installation

### Carthage

Just add your `Cartfile`

```
github "fumito-ito/SwiftyInAppMessaging" ~> 0.2.1
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
        .package(url: "https://github.com/fumito-ito/SwiftyInAppMessaging.git", .upToNextMajor(from: "0.2.1"))
    ]
)
```

firebase ios sdk supports Swift Package Manager in **Beta**. If you have some issues caused in Swift Package Manager, Please check firebase issues.

### Cocoapods

Just add to your `Podfile`

```
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
