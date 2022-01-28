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

protocol InAppDefaultModalViewDelegate: AnyObject {
    func actionButtonDidTap()
}

final class InAppDefaultModalView: UIView {
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .boldSystemFont(ofSize: FontSize.label)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true

        return view
    }()

    lazy var bodyLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: FontSize.body)
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
        view.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.button)
        view.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        return view
    }()

    weak var delegate: InAppDefaultModalViewDelegate?

    private var currentConstrains: [NSLayoutConstraint] = []

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

        if let buttonText = actionButton?.buttonText {
            self.actionButton.setTitle(buttonText, for: .normal)

            if let buttonTextColor = actionButton?.buttonTextColor {
                self.actionButton.setTitleColor(buttonTextColor, for: .normal)
            }

            if let buttonBackgroundColor = actionButton?.buttonBackgroundColor {
                self.actionButton.setBackgroundImage(buttonBackgroundColor.image(), for: .normal)
            }

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

        self.currentConstrains.append(contentsOf: [
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),

            self.titleLabel.topAnchor.constraint(equalTo: self.imageView.topAnchor),
            self.titleLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),

            self.bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.bodyLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.bodyLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),

            self.actionButton.topAnchor.constraint(greaterThanOrEqualTo: self.bodyLabel.bottomAnchor, constant: 16),
            self.actionButton.centerXAnchor.constraint(equalTo: self.bodyLabel.centerXAnchor),
            self.actionButton.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            self.actionButton.heightAnchor.constraint(equalToConstant: 30),
            self.actionButton.leftAnchor.constraint(greaterThanOrEqualTo: self.imageView.rightAnchor, constant: 16),
            self.actionButton.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: -16)
        ])

        if self.imageView.image != nil {
            self.currentConstrains.append(contentsOf: [
                self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
                self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1.0),
            ])
        }

        if #available(iOS 13.0, *) {} else {
            let superViewWidth = self.superview?.frame.width ?? 0
            let widthToLayoutView = self.calculateReadableContentGuideMargin(for: superViewWidth)
            let imageWidth = (superViewWidth - widthToLayoutView.left - widthToLayoutView.right) / 3 + 16
            let labelInsets = UIEdgeInsets(top: 0, left: imageWidth + 16, bottom: 0, right: 16)

            self.currentConstrains.append(contentsOf: [
                self.titleLabel.heightAnchor.constraint(equalToConstant: self.calculateLabelHeight(for: self.titleLabel, of: self.superview, with: labelInsets)),
                self.bodyLabel.heightAnchor.constraint(equalToConstant: self.calculateLabelHeight(for: self.bodyLabel, of: self.superview, with: labelInsets)),
            ])
        }

        NSLayoutConstraint.activate(self.currentConstrains)
    }

    private func applyCompactLayout() {
        self.clearConstraints()

        self.currentConstrains.append(contentsOf: [
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),

            self.imageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.imageView.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.imageView.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),
        ])

        if self.imageView.image != nil {
            self.currentConstrains.append(self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1.0))
        }

        self.currentConstrains.append(contentsOf: [
            self.bodyLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: self.bodyLabelPadding),
            self.bodyLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.bodyLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),

            self.actionButton.topAnchor.constraint(equalTo: self.bodyLabel.bottomAnchor, constant: self.actionButtonPadding),
            self.actionButton.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.actionButton.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),
            self.actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.actionButton.heightAnchor.constraint(equalToConstant: 30),
        ])

        // layout hack for iOS 12.
        if #available(iOS 13.0, *) { } else {
            let labelInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            self.currentConstrains.append(contentsOf: [
                self.titleLabel.heightAnchor.constraint(equalToConstant: self.calculateLabelHeight(for: self.titleLabel, of: self.superview, with: labelInsets)),
                self.bodyLabel.heightAnchor.constraint(equalToConstant: self.calculateLabelHeight(for: self.bodyLabel, of: self.superview, with: labelInsets)),
            ])
        }

        NSLayoutConstraint.activate(self.currentConstrains)
    }

    private func clearConstraints() {
        NSLayoutConstraint.deactivate(self.currentConstrains)
        self.currentConstrains = []
    }

    @available(iOS, introduced: 12.0, obsoleted: 13.0)
    private func calculateLabelHeight(for label: UILabel, of view: UIView?, with insets: UIEdgeInsets) -> CGFloat {
        guard let view = view else {
            return 0
        }

        let readableContentMargins = self.calculateReadableContentGuideMargin(for: view.frame.width)
        let layoutWidth = view.frame.width - (readableContentMargins.left + readableContentMargins.right) - (insets.left + insets.right)
        let size = CGSize(width: layoutWidth, height: CGFloat.greatestFiniteMagnitude)

        return label.sizeThatFits(size).height
    }

    /// calculate layout marging for readable content guide.
    ///
    /// This function solves the problem that autolayout dose not calculate the width properly on iOS 12.
    /// If screen with is
    /// * 375>= ... left and right margins are 16
    /// * 672>, >375... left and right margins are 20
    /// * 672>= ... margins are calculated by (view width - 672). but if calculated margins are 20>, it returns 20.
    ///
    /// - Parameter width: screen width
    /// - Returns: layout margin for readable content guide.
    @available(iOS, introduced: 12.0, obsoleted: 13.0)
    private func calculateReadableContentGuideMargin(for width: CGFloat) -> UIEdgeInsets {
        let minMargin: CGFloat = 16
        let normalMargin: CGFloat = 20

        let minWidth: CGFloat = 375
        let maxWidth: CGFloat = 672

        if width <= minWidth {
            return UIEdgeInsets(top: 0, left: minMargin, bottom: 0, right: minMargin)
        }

        if width >= maxWidth {
            let maxMargin = (width - maxWidth)
            let margin = max(maxMargin, normalMargin)

            return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        }

        return UIEdgeInsets(top: 0, left: normalMargin, bottom: 0, right: normalMargin)
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
        NSLayoutConstraint.activate([
            self.modalView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.modalView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.modalView.leftAnchor.constraint(equalTo: self.view.readableContentGuide.leftAnchor),
            self.modalView.rightAnchor.constraint(equalTo: self.view.readableContentGuide.rightAnchor),
        ])
        self.modalView.applyLayout(for: self.traitCollection.horizontalSizeClass)

        self.modalView.delegate = self
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard self.traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass else {
            return
        }

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
    }
}

extension InAppDefaultModalMessageViewController: InAppDefaultModalViewDelegate {
    public func actionButtonDidTap() {

        if let actionURL = self.actionURL, UIApplication.shared.canOpenURL(actionURL) {
            UIApplication.shared.open(actionURL, options: [:], completionHandler: nil)
        }

        let action = InAppMessagingAction(actionText: self.actionButtonText, actionURL: self.actionURL)
        eventDetector.messageClicked(with: action)
    }
}
#endif
