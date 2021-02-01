//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import Foundation
import UIKit
import FirebaseInAppMessaging

public protocol InAppDefaultImageOnlyViewDelegate {
    func imageDidTap()
}

final class InAppDefaultImageOnlyView: UIView {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 8
        view.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageDidTap))
        view.addGestureRecognizer(tapGesture)

        return view
    }()

    var delegate: InAppDefaultImageOnlyViewDelegate?

    init(image: UIImage?) {

        super.init(frame: .zero)

        self.imageView.image = image
        self.addSubview(self.imageView)

        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = false
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

        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor).isActive = true
    }

    private func applyCompactLayout() {
        self.clearConstraints()

        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor).isActive = true
    }

    private func clearConstraints() {
        self.removeConstraints(self.constraints)
        self.imageView.removeConstraints(self.imageView.constraints)
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
        self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.view.addSubview(imageView)
        self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.imageView.topAnchor.constraint(lessThanOrEqualTo: self.view.topAnchor, constant: 32).isActive = true
        self.imageView.leftAnchor.constraint(lessThanOrEqualTo: self.view.leftAnchor, constant: 32).isActive = true
        self.imageView.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -32).isActive = true
        self.imageView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -32).isActive = true
        self.imageView.applyLayout(for: self.traitCollection.horizontalSizeClass)

        self.imageView.delegate = self
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
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
        self.dismiss(animated: true, completion: nil)
    }
}

extension InAppDefaultImageOnlyMessageViewController: InAppDefaultImageOnlyViewDelegate {
    public func imageDidTap() {
        let action = InAppMessagingAction(actionText: nil, actionURL: self.actionURL)
        eventDetector.messageClicked(with: action)

        if let actionURL = self.actionURL, UIApplication.shared.canOpenURL(actionURL) {
            UIApplication.shared.open(actionURL, options: [:], completionHandler: nil)
        }

        self.dismiss(animated: false, completion: nil)
    }
}
