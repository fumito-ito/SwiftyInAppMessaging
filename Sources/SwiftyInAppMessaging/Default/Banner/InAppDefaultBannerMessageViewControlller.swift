//
//  InAppDefaultBannerMessageView.swift
//  SwiftyInAppMessaging
//
//  Created by 伊藤史 on 2021/01/19.
//
#if os(iOS) || os(tvOS)
    import FirebaseInAppMessaging
    import Foundation
    import UIKit

    final class InAppDefaultBannerMessageViewController: UIViewController {
        let bannerView: InAppDefaultBannerMessageView

        let eventDetector: MessageEventDetectable

        let actionURL: URL?
        let bannerTitle: String
        private(set) var autoDismissTimer: Timer?
        private(set) var hideBannerConstraint: NSLayoutConstraint?
        private(set) var showBannerConstraint: NSLayoutConstraint?

        init(
            title: String,
            image: UIImage?,
            bodyText: String?,
            backgroundColor: UIColor,
            textColor: UIColor,
            actionURL: URL?,
            eventDetector: MessageEventDetectable
        ) {

            self.bannerView = InAppDefaultBannerMessageView(
                title: title,
                image: image,
                bodyText: bodyText,
                backgroundColor: backgroundColor,
                textColor: textColor)

            self.eventDetector = eventDetector
            self.actionURL = actionURL
            self.bannerTitle = title

            super.init(nibName: nil, bundle: nil)

            self.modalPresentationStyle = .overFullScreen
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            self.view.addSubview(self.bannerView)
            self.applyLayout()

            self.bannerView.delegate = self
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.showBanner(completion: { [weak self] completed in
                guard let `self` = self, completed else {
                    return
                }

                self.autoDismissTimer = Timer.scheduledTimer(
                    timeInterval: TimeInterval(3.0),
                    target: self,
                    selector: #selector(self.dismissByTimer),
                    userInfo: nil,
                    repeats: false)
            })
        }

        func applyLayout() {
            let hideBannerConstraint = self.bannerView.bottomAnchor.constraint(
                equalTo: self.view.topAnchor)
            self.hideBannerConstraint = hideBannerConstraint

            let statusBarHeight: CGFloat
            #if os(tvOS)
                statusBarHeight = 0
            #else
                statusBarHeight = UIApplication.shared.statusBarFrame.size.height
            #endif

            self.showBannerConstraint = self.bannerView.topAnchor.constraint(
                equalTo: self.view.topAnchor, constant: statusBarHeight)

            NSLayoutConstraint.activate([
                self.bannerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
                self.bannerView.rightAnchor.constraint(
                    equalTo: self.view.rightAnchor, constant: -16),
                hideBannerConstraint,
            ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc private func dismissByTimer() {
            self.hideBanner(completion: { [weak self] _ in
                self?.eventDetector.messageDismissed(dismissType: .typeAuto)
            })
        }

        @objc private func hideBanner(completion: ((Bool) -> Void)? = nil) {
            self.bannerView.hideBanner(
                for: self.view,
                completion: { [weak self] completed in
                    self?.showBannerConstraint?.isActive = false
                    self?.hideBannerConstraint?.isActive = true
                    completion?(completed)
                })
        }

        private func showBanner(completion: ((Bool) -> Void)? = nil) {
            self.bannerView.showBanner(
                for: self.view,
                completion: { [weak self] completed in
                    self?.hideBannerConstraint?.isActive = false
                    self?.showBannerConstraint?.isActive = true
                    completion?(completed)
                })
        }
    }

    extension InAppDefaultBannerMessageViewController: InAppDefaultBannerMessageViewDelegate {
        func bannerDidTapped(_: InAppDefaultBannerMessageView) {
            if let url = self.actionURL, UIApplication.shared.canOpenURL(url) {
                self.hideBanner(completion: { [weak self] _ in
                    let action = InAppMessagingAction(
                        actionText: self?.title, actionURL: self?.actionURL)
                    self?.eventDetector.messageClicked(with: action)
                })

                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        func bannerDidPanned(_: InAppDefaultBannerMessageView) {
            self.hideBanner(completion: { [weak self] _ in
                self?.eventDetector.messageDismissed(dismissType: .typeUserSwipe)
            })
        }
    }
#endif
