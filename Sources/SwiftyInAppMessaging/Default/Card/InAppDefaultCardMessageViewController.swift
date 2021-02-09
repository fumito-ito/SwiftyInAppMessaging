//
//  File.swift
//
//
//  Created by 伊藤史 on 2021/01/05.
//

import FirebaseInAppMessaging
import Foundation
import UIKit

public protocol InAppDefaultCardViewDelegate: class {
    func primaryActionButtonDidTap()
    func secondaryActionButtonDidTap()
}

final class InAppDefaultCardView: UIView {
    private let portraitImage: UIImage
    private let landscapeImage: UIImage?

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var bodyLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var primaryActionButton: UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)

        return view
    }()

    lazy var secondaryActionButton: UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)

        return view
    }()

    lazy var buttonContainerStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            self.primaryActionButton
        ])
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .fillEqually

        return view
    }()

    lazy var containerStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            self.titleLabel,
            self.bodyLabel,
            self.buttonContainerStack
        ])
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    weak var delegate: InAppDefaultCardViewDelegate?

    init(title: String,
         portraitImage: UIImage,
         landscapeImage: UIImage?,
         bodyText: String?,
         primaryActionButton: ActionButton,
         secondaryActionButton: ActionButton?,
         backgroundColor: UIColor,
         textColor: UIColor) {

        self.portraitImage = portraitImage
        self.landscapeImage = landscapeImage

        super.init(frame: .zero)

        self.imageView.image = portraitImage
        self.addSubview(self.imageView)

        self.titleLabel.text = title
        self.titleLabel.textColor = textColor

        self.bodyLabel.text = bodyText
        self.bodyLabel.textColor = textColor

        self.primaryActionButton.setTitle(primaryActionButton.buttonText, for: .normal)
        self.primaryActionButton.setTitleColor(primaryActionButton.buttonTextColor, for: .normal)
        self.primaryActionButton.setBackgroundImage(primaryActionButton.buttonBackgroundColor.image(), for: .normal)
        self.primaryActionButton.addTarget(self, action: #selector(primaryButtonDidTap), for: .touchUpInside)
        self.primaryActionButton.isUserInteractionEnabled = true

        if let buttonText = secondaryActionButton?.buttonText,
           let buttonTextColor = secondaryActionButton?.buttonTextColor,
           let buttonBackgroundColor = secondaryActionButton?.buttonBackgroundColor {
            self.secondaryActionButton.setTitle(buttonText, for: .normal)
            self.secondaryActionButton.setTitleColor(buttonTextColor, for: .normal)
            self.secondaryActionButton.setBackgroundImage(buttonBackgroundColor.image(), for: .normal)

            self.secondaryActionButton.addTarget(self, action: #selector(secondaryButtonDidTap), for: .touchUpInside)
            self.secondaryActionButton.isUserInteractionEnabled = true

            self.buttonContainerStack.insertArrangedSubview(self.secondaryActionButton, at: 0)
        }

        self.addSubview(self.containerStack)

        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc func primaryButtonDidTap() {
        self.delegate?.primaryActionButtonDidTap()
    }

    @objc func secondaryButtonDidTap() {
        self.delegate?.secondaryActionButtonDidTap()
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

        self.imageView.image = landscapeImage ?? portraitImage

        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        self.containerStack.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 16).isActive = true
        self.containerStack.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16).isActive = true
        self.containerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        self.containerStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
    }

    private func applyCompactLayout() {
        self.clearConstraints()

        self.imageView.image = portraitImage

        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 3/2).isActive = true

        self.containerStack.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 8).isActive = true
        self.containerStack.leftAnchor.constraint(equalTo: self.imageView.leftAnchor, constant: 16).isActive = true
        self.containerStack.rightAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: -16).isActive = true
        self.containerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
    }

    private func clearConstraints() {
        self.imageView.removeConstraints(self.imageView.constraints)
        self.containerStack.removeConstraints(self.containerStack.constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class InAppDefaultCardMessageViewController: UIViewController {

    let cardView: InAppDefaultCardView

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

    let primaryActionButtonText: String?

    let primaryActionURL: URL?

    let secondaryActionButtonText: String?

    let secondaryActionURL: URL?

    init(title: String,
         portraitImage: UIImage,
         landscapeImage: UIImage?,
         bodyText: String?,
         primaryActionButton: ActionButton,
         primaryActionURL: URL?,
         secondaryActionButton: ActionButton?,
         secondaryActionURL: URL?,
         backgroundColor: UIColor,
         textColor: UIColor,
         eventDetector: MessageEventDetectable) {

        self.cardView = InAppDefaultCardView(title: title,
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

        self.view.addSubview(self.backgroundView)
        self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.view.addSubview(cardView)
        self.cardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.cardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.cardView.leftAnchor.constraint(lessThanOrEqualTo: self.view.leftAnchor, constant: 32).isActive = true
        self.cardView.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -32).isActive = true
        self.cardView.applyLayout(for: self.traitCollection.horizontalSizeClass)

        self.cardView.delegate = self
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.cardView.applyLayout(for: self.traitCollection.horizontalSizeClass)
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

extension InAppDefaultCardMessageViewController: InAppDefaultCardViewDelegate {
    public func primaryActionButtonDidTap() {
        let action = InAppMessagingAction(actionText: self.primaryActionButtonText, actionURL: self.primaryActionURL)
        eventDetector.messageClicked(with: action)

        if let actionURL = self.primaryActionURL, UIApplication.shared.canOpenURL(actionURL) {
            UIApplication.shared.open(actionURL, options: [:], completionHandler: nil)
        } else {
            self.eventDetector.messageDismissed(dismissType: .typeUserTapClose)
        }

        self.dismiss(animated: false, completion: nil)
    }

    public func secondaryActionButtonDidTap() {
        let action = InAppMessagingAction(actionText: self.secondaryActionButtonText, actionURL: self.secondaryActionURL)
        eventDetector.messageClicked(with: action)

        if let actionURL = self.secondaryActionURL, UIApplication.shared.canOpenURL(actionURL) {
            UIApplication.shared.open(actionURL, options: [:], completionHandler: nil)
        } else {
            self.eventDetector.messageDismissed(dismissType: .typeUserTapClose)
        }

        self.dismiss(animated: false, completion: nil)
    }
}
