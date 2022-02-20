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

    final class InAppDefaultModalMessageViewController: UIViewController {

        let modalView: InAppDefaultModalView

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

        let actionButtonText: String?

        let actionURL: URL?

        private var currentConstraints: [NSLayoutConstraint] = []

        init(
            title: String,
            image: UIImage?,
            bodyText: String?,
            actionButton: ActionButton?,
            actionURL: URL?,
            backgroundColor: UIColor,
            textColor: UIColor,
            eventDetector: MessageEventDetectable
        ) {

            self.modalView = InAppDefaultModalView(
                title: title,
                image: image,
                bodyText: bodyText,
                actionButton: actionButton,
                backgroundColor: backgroundColor,
                textColor: textColor)
            self.eventDetector = eventDetector
            self.actionButtonText = actionButton?.buttonText
            self.actionURL = actionURL

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

            self.view.addSubview(modalView)
            applyLayout(
                for: UIApplication.interfaceOrientation,
                with: self.traitCollection.horizontalSizeClass)
            self.modalView.delegate = self
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
        }

        private func applyLayout(
            for orientation: UIInterfaceOrientation,
            with horizontalSizeClass: UIUserInterfaceSizeClass
        ) {
            clearLayout()

            switch (orientation.isPortrait, horizontalSizeClass) {
            case (true, _):
                applyPortraitLayout()
                modalView.applyLayout(for: horizontalSizeClass)
            case (false, .compact):
                applyLandscapeLayout()
                modalView.applyLayout(for: .regular)
            case (false, _):
                applyLandscapeLayout()
                modalView.applyLayout(for: horizontalSizeClass)
            }
        }

        private func applyPortraitLayout() {
            currentConstraints.append(contentsOf: [
                self.modalView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.modalView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                self.modalView.leftAnchor.constraint(
                    equalTo: self.view.readableContentGuide.leftAnchor),
                self.modalView.rightAnchor.constraint(
                    equalTo: self.view.readableContentGuide.rightAnchor),
            ])

            NSLayoutConstraint.activate(currentConstraints)
        }

        private func applyLandscapeLayout() {
            currentConstraints.append(contentsOf: [
                self.modalView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.modalView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                self.modalView.leftAnchor.constraint(
                    equalTo: self.view.readableContentGuide.leftAnchor),
                self.modalView.rightAnchor.constraint(
                    equalTo: self.view.readableContentGuide.rightAnchor),
            ])

            NSLayoutConstraint.activate(currentConstraints)
        }

        private func clearLayout() {
            NSLayoutConstraint.deactivate(currentConstraints)
            currentConstraints = []
        }
    }

    extension InAppDefaultModalMessageViewController: InAppDefaultModalViewDelegate {
        public func actionButtonDidTap() {

            if let actionURL = self.actionURL, UIApplication.shared.canOpenURL(actionURL) {
                UIApplication.shared.open(actionURL, options: [:], completionHandler: nil)
            }

            let action = InAppMessagingAction(
                actionText: self.actionButtonText, actionURL: self.actionURL)
            eventDetector.messageClicked(with: action)
        }
    }
#endif
