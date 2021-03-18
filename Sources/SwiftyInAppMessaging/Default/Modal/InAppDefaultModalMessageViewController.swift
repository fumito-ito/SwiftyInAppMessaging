//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import Firebase
import Foundation
import UIKit

public protocol InAppDefaultModalViewDelegate: class {
    func actionButtonDidTap()
}

final class InAppDefaultModalView: UIView {
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var bodyLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var actionButton: UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)

        return view
    }()

    weak var delegate: InAppDefaultModalViewDelegate?

    private var bodyLabelPadding: CGFloat {
        if self.bodyLabel.text == nil || self.bodyLabel.text?.isEmpty == true {
            return 0
        } else {
            return 16
        }
    }

    private var actionButtonPadding: CGFloat {
        if self.actionButton.titleLabel?.text == nil || self.actionButton.titleLabel?.text?.isEmpty == true {
            return 0
        } else {
            return 16
        }
    }

    init(title: String,
         image: UIImage?,
         bodyText: String?,
         actionButton: ActionButton?,
         backgroundColor: UIColor,
         textColor: UIColor) {

        super.init(frame: .zero)

        self.titleLabel.text = title
        self.titleLabel.textColor = textColor
        self.addSubview(self.titleLabel)

        self.imageView.image = image
        self.addSubview(self.imageView)

        self.bodyLabel.text = bodyText
        self.bodyLabel.textColor = textColor
        self.addSubview(self.bodyLabel)

        if let buttonText = actionButton?.buttonText,
           let buttonTextColor = actionButton?.buttonTextColor,
           let buttonBackgroundColor = actionButton?.buttonBackgroundColor {
            self.actionButton.setTitle(buttonText, for: .normal)
            self.actionButton.setTitleColor(buttonTextColor, for: .normal)
            self.actionButton.setBackgroundImage(buttonBackgroundColor.image(), for: .normal)

            self.actionButton.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
            self.actionButton.isUserInteractionEnabled = true
        }
        self.addSubview(self.actionButton)

        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc func buttonDidTap() {
        self.delegate?.actionButtonDidTap()
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

        self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        if self.imageView.image != nil {
            self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1.0).isActive = true
        }

        self.titleLabel.topAnchor.constraint(equalTo: self.imageView.topAnchor).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 16).isActive = true

        self.bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: self.bodyLabelPadding).isActive = true
        self.bodyLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor).isActive = true
        self.bodyLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor).isActive = true

        self.actionButton.topAnchor.constraint(equalTo: self.bodyLabel.bottomAnchor, constant: self.actionButtonPadding).isActive = true
        self.actionButton.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor).isActive = true
        self.actionButton.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor).isActive = true
        self.actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
    }

    private func applyCompactLayout() {
        self.clearConstraints()

        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true

        self.imageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor).isActive = true
        if self.imageView.image != nil {
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1.0).isActive = true
        }

        self.bodyLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: self.bodyLabelPadding).isActive = true
        self.bodyLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor).isActive = true
        self.bodyLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor).isActive = true

        self.actionButton.topAnchor.constraint(equalTo: self.bodyLabel.bottomAnchor, constant: self.actionButtonPadding).isActive = true
        self.actionButton.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor).isActive = true
        self.actionButton.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor).isActive = true
        self.actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
    }

    private func clearConstraints() {
        self.titleLabel.removeConstraints(self.titleLabel.constraints)
        self.imageView.removeConstraints(self.imageView.constraints)
        self.bodyLabel.removeConstraints(self.bodyLabel.constraints)
        self.actionButton.removeConstraints(self.actionButton.constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class InAppDefaultModalMessageViewController: UIViewController {

    let modalView: InAppDefaultModalView

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

    let actionButtonText: String?

    let actionURL: URL?

    init(title: String,
         image: UIImage?,
         bodyText: String?,
         actionButton: ActionButton?,
         actionURL: URL?,
         backgroundColor: UIColor,
         textColor: UIColor,
         eventDetector: MessageEventDetectable) {

        self.modalView = InAppDefaultModalView(title: title,
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

        self.view.addSubview(self.backgroundView)
        self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.view.addSubview(modalView)
        self.modalView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.modalView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.modalView.leftAnchor.constraint(lessThanOrEqualTo: self.view.leftAnchor, constant: 32).isActive = true
        self.modalView.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -32).isActive = true
        self.modalView.applyLayout(for: self.traitCollection.horizontalSizeClass)

        self.modalView.delegate = self
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.modalView.applyLayout(for: self.traitCollection.horizontalSizeClass)
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
}

extension InAppDefaultModalMessageViewController: InAppDefaultModalViewDelegate {
    public func actionButtonDidTap() {
        let action = InAppMessagingAction(actionText: self.actionButtonText, actionURL: self.actionURL)
        eventDetector.messageClicked(with: action)

        if let actionURL = self.actionURL, UIApplication.shared.canOpenURL(actionURL) {
            UIApplication.shared.open(actionURL, options: [:], completionHandler: nil)
        }

        self.dismissView()
    }
}
