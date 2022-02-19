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

final class InAppDefaultImageOnlyMessageViewController: UIViewController {

    let imageOnlyView: InAppDefaultImageOnlyView

    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.backgroundViewDidTap))
        view.addGestureRecognizer(tapGesture)

        return view
    }()

    let eventDetector: MessageEventDetectable

    let actionURL: URL?

    private var currentConstraints: [NSLayoutConstraint] = []

    init(image: UIImage?,
         actionURL: URL?,
         eventDetector: MessageEventDetectable) {

        self.imageOnlyView = InAppDefaultImageOnlyView(image: image)
        self.eventDetector = eventDetector
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

        self.view.addSubview(self.imageOnlyView)
        applyLayout(for: UIApplication.interfaceOrientation, with: self.traitCollection.horizontalSizeClass)
        self.imageOnlyView.delegate = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        applyLayout(for: UIApplication.interfaceOrientation, with: self.traitCollection.horizontalSizeClass)
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

    private func applyLayout(for orientation: UIInterfaceOrientation, with horizontalSizeClass: UIUserInterfaceSizeClass) {
        clearLayout()

        switch (orientation.isPortrait, horizontalSizeClass) {
        case (true, _):
            applyPortraitLayout()
            imageOnlyView.applyLayout(for: horizontalSizeClass)
        case (false, .compact):
            applyLandscapeLayout()
            imageOnlyView.applyLayout(for: .regular)
        case (false, _):
            applyLandscapeLayout()
            imageOnlyView.applyLayout(for: horizontalSizeClass)
        }
    }

    private func applyPortraitLayout() {
        currentConstraints.append(contentsOf: [
            self.imageOnlyView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageOnlyView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.imageOnlyView.leftAnchor.constraint(equalTo: self.view.readableContentGuide.leftAnchor),
            self.imageOnlyView.rightAnchor.constraint(equalTo: self.view.readableContentGuide.rightAnchor),
            self.imageOnlyView.heightAnchor.constraint(equalTo: self.imageOnlyView.widthAnchor),
        ])

        NSLayoutConstraint.activate(currentConstraints)
    }

    private func applyLandscapeLayout() {
        currentConstraints.append(contentsOf: [
            self.imageOnlyView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageOnlyView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.imageOnlyView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.imageOnlyView.heightAnchor.constraint(equalTo: self.imageOnlyView.widthAnchor),
        ])

        NSLayoutConstraint.activate(currentConstraints)
    }

    private func clearLayout() {
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints = []
    }
}

extension InAppDefaultImageOnlyMessageViewController: InAppDefaultImageOnlyViewDelegate {
    public func imageDidTap() {
        if let actionURL = self.actionURL, UIApplication.shared.canOpenURL(actionURL) {
            UIApplication.shared.open(actionURL, options: [:], completionHandler: nil)
        }

        let action = InAppMessagingAction(actionText: nil, actionURL: self.actionURL)
        eventDetector.messageClicked(with: action)
    }
}
#endif
