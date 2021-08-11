//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import FirebaseInAppMessaging
import Foundation
import UIKit

protocol InAppDefaultImageOnlyViewDelegate: class {
    func imageDidTap()
}

final class InAppDefaultImageOnlyView: UIView {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageDidTap))
        view.addGestureRecognizer(tapGesture)

        return view
    }()

    weak var delegate: InAppDefaultImageOnlyViewDelegate?

    private var currentConstraints: [NSLayoutConstraint] = []

    init(image: UIImage?) {

        super.init(frame: .zero)

        self.imageView.image = image
        self.addSubview(self.imageView)

        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = false
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }

    @objc func imageDidTap() {
        self.delegate?.imageDidTap()
    }

    func applyLayout(for horizontalSizeClass: UIUserInterfaceSizeClass) {
        switch horizontalSizeClass {
        case .compact, .unspecified:
            self.applyCompactLayout()
        case .regular:
            self.applyReguarLayout()
        @unknown default:
            self.applyCompactLayout()
        }
    }

    private func applyReguarLayout() {
        self.clearConstraints()

        self.currentConstraints.append(contentsOf: [
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor),
        ])

        NSLayoutConstraint.activate(self.currentConstraints)
    }

    private func applyCompactLayout() {
        self.clearConstraints()

        self.currentConstraints.append(contentsOf: [
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor),
        ])

        NSLayoutConstraint.activate(self.currentConstraints)
    }

    private func clearConstraints() {
        NSLayoutConstraint.deactivate(self.currentConstraints)
        self.currentConstraints = []
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class InAppDefaultImageOnlyMessageViewController: UIViewController {

    let imageView: InAppDefaultImageOnlyView

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

    init(image: UIImage?,
         actionURL: URL?,
         eventDetector: MessageEventDetectable) {

        self.imageView = InAppDefaultImageOnlyView(image: image)
        self.eventDetector = eventDetector
        self.actionURL = actionURL

        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve

        self.view.addSubview(self.backgroundView)
        NSLayoutConstraint.activate([
            self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])

        self.view.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.imageView.leftAnchor.constraint(equalTo: self.view.readableContentGuide.leftAnchor),
            self.imageView.rightAnchor.constraint(equalTo: self.view.readableContentGuide.rightAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor),
        ])
        self.imageView.applyLayout(for: self.traitCollection.horizontalSizeClass)

        self.imageView.delegate = self
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard self.traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass else {
            return
        }

        self.imageView.applyLayout(for: self.traitCollection.horizontalSizeClass)
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
