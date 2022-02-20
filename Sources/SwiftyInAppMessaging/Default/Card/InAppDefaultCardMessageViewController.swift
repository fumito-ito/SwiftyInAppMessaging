//
//  File.swift
//
//
//  Created by 伊藤史 on 2021/01/05.
//
#if os(iOS) || os(tvOS)
    import FirebaseInAppMessaging
    import Foundation
    import UIKit

    final class InAppDefaultCardMessageViewController: UIViewController {

        let cardView: InAppDefaultCardMessageView

        lazy var backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.layer.opacity = 0.5
            view.translatesAutoresizingMaskIntoConstraints = false

            let tapGesture = UITapGestureRecognizer(
                target: self, action: #selector(self.backgroundViewDidTap))
            view.addGestureRecognizer(tapGesture)

            return view
        }()

        let eventDetector: MessageEventDetectable

        let primaryActionButtonText: String?

        let primaryActionURL: URL?

        let secondaryActionButtonText: String?

        let secondaryActionURL: URL?

        private var currentConstraints: [NSLayoutConstraint] = []

        init(
            title: String,
            portraitImage: UIImage,
            landscapeImage: UIImage?,
            bodyText: String?,
            primaryActionButton: ActionButton,
            primaryActionURL: URL?,
            secondaryActionButton: ActionButton?,
            secondaryActionURL: URL?,
            backgroundColor: UIColor,
            textColor: UIColor,
            eventDetector: MessageEventDetectable
        ) {

            self.cardView = InAppDefaultCardMessageView(
                title: title,
                portraitImage: portraitImage,
                landscapeImage: landscapeImage,
                bodyText: bodyText,
                primaryActionButton: primaryActionButton,
                secondaryActionButton: secondaryActionButton,
                backgroundColor: backgroundColor,
                textColor: textColor)
            self.eventDetector = eventDetector
            self.primaryActionButtonText = primaryActionButton.buttonText
            self.primaryActionURL = primaryActionURL
            self.secondaryActionButtonText = secondaryActionButton?.buttonText
            self.secondaryActionURL = secondaryActionURL

            super.init(nibName: nil, bundle: nil)

            self.modalPresentationStyle = .overFullScreen
            self.modalTransitionStyle = .crossDissolve
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            self.view.addSubview(self.backgroundView)
            NSLayoutConstraint.activate([
                self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                self.backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                self.backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])

            self.view.addSubview(self.cardView)
            applyLayout(
                for: UIApplication.interfaceOrientation, with: traitCollection.horizontalSizeClass)

            self.cardView.delegate = self
        }

        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            applyLayout(
                for: UIApplication.interfaceOrientation, with: traitCollection.horizontalSizeClass)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.eventDetector.impressionDetected()
        }

        @objc func backgroundViewDidTap() {
            self.eventDetector.messageDismissed(dismissType: .typeUserTapClose)
            self.dismissView()
        }

        private func applyLayout(
            for orientation: UIInterfaceOrientation,
            with horizontalSizeClass: UIUserInterfaceSizeClass
        ) {
            clearLayout()

            switch (orientation.isPortrait, horizontalSizeClass) {
            case (true, _):
                applyPortraitLayout()
                cardView.applyLayout(for: horizontalSizeClass)
            case (false, .compact):
                applyLandscapeLayout(for: horizontalSizeClass)
                cardView.applyLayout(for: .regular)
            case (false, _):
                applyLandscapeLayout(for: horizontalSizeClass)
                cardView.applyLayout(for: horizontalSizeClass)
            }
        }

        private func applyLandscapeLayout(for horizontalSizeClass: UIUserInterfaceSizeClass) {
            let readableContentGuidePriority: UILayoutPriority =
                horizontalSizeClass == .regular ? .required : .defaultHigh
            let leftAnchor = self.cardView.leftAnchor.constraint(
                lessThanOrEqualTo: self.view.readableContentGuide.leftAnchor)
            leftAnchor.priority = readableContentGuidePriority

            let rightAnchor = self.cardView.rightAnchor.constraint(
                lessThanOrEqualTo: self.view.readableContentGuide.rightAnchor)
            rightAnchor.priority = readableContentGuidePriority

            currentConstraints.append(contentsOf: [
                self.cardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.cardView.topAnchor.constraint(
                    equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
                self.cardView.bottomAnchor.constraint(
                    equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                leftAnchor,
                rightAnchor,
            ])

            NSLayoutConstraint.activate(currentConstraints)
        }

        private func applyPortraitLayout() {
            currentConstraints.append(contentsOf: [
                self.cardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.cardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                self.cardView.leftAnchor.constraint(
                    equalTo: self.view.readableContentGuide.leftAnchor),
                self.cardView.rightAnchor.constraint(
                    equalTo: self.view.readableContentGuide.rightAnchor),
            ])

            NSLayoutConstraint.activate(currentConstraints)
        }

        private func clearLayout() {
            NSLayoutConstraint.deactivate(currentConstraints)
            currentConstraints = []
        }
    }

    extension InAppDefaultCardMessageViewController: InAppDefaultCardMessageViewDelegate {
        public func primaryActionButtonDidTap() {

            if let actionURL = self.primaryActionURL, UIApplication.shared.canOpenURL(actionURL) {
                UIApplication.shared.open(actionURL, options: [:], completionHandler: nil)
            }

            let action = InAppMessagingAction(
                actionText: self.primaryActionButtonText, actionURL: self.primaryActionURL)
            eventDetector.messageClicked(with: action)
        }

        public func secondaryActionButtonDidTap() {

            if let actionURL = self.secondaryActionURL, UIApplication.shared.canOpenURL(actionURL) {
                UIApplication.shared.open(actionURL, options: [:], completionHandler: nil)
            }

            let action = InAppMessagingAction(
                actionText: self.secondaryActionButtonText, actionURL: self.secondaryActionURL)
            eventDetector.messageClicked(with: action)
        }
    }
#endif
