//
//  InAppDefaultCardMessageView.swift
//
//
//  Created by 伊藤史 on 2022/02/19.
//
#if os(iOS) || os(tvOS)
import FirebaseInAppMessaging
import Foundation
import UIKit

protocol InAppDefaultCardMessageViewDelegate: AnyObject {
    func primaryActionButtonDidTap()
    func secondaryActionButtonDidTap()
}

final class InAppDefaultCardMessageView: UIView {
    private let portraitImage: UIImage
    private let landscapeImage: UIImage?

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true

        return view
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .boldSystemFont(ofSize: FontSize.label)
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var bodyLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: FontSize.body)
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var primaryActionButton: UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.button)
        view.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        return view
    }()

    lazy var secondaryActionButton: UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.button)
        view.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        return view
    }()

    weak var delegate: InAppDefaultCardMessageViewDelegate?

    private var currentConstraints: [NSLayoutConstraint] = []

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
        self.addSubview(self.titleLabel)

        self.bodyLabel.text = bodyText
        self.bodyLabel.textColor = textColor
        self.addSubview(self.bodyLabel)

        self.primaryActionButton.setTitle(primaryActionButton.buttonText, for: .normal)
        self.primaryActionButton.setTitleColor(primaryActionButton.buttonTextColor, for: .normal)
        self.primaryActionButton.addTarget(self, action: #selector(primaryButtonDidTap), for: .touchUpInside)
        self.primaryActionButton.isUserInteractionEnabled = true
        self.addSubview(self.primaryActionButton)

        if let buttonText = secondaryActionButton?.buttonText {
            self.secondaryActionButton.setTitle(buttonText, for: .normal)

            if let buttonTextColor = secondaryActionButton?.buttonTextColor {
                self.secondaryActionButton.setTitleColor(buttonTextColor, for: .normal)
            }

            self.secondaryActionButton.addTarget(self, action: #selector(secondaryButtonDidTap), for: .touchUpInside)
            self.secondaryActionButton.isUserInteractionEnabled = true

            self.addSubview(self.secondaryActionButton)
        }

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

        self.currentConstraints.append(contentsOf: [
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1.0),
            self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2),

            self.titleLabel.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 16),
            self.titleLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),

            self.bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.bodyLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.bodyLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),

            self.primaryActionButton.topAnchor.constraint(greaterThanOrEqualTo: self.bodyLabel.bottomAnchor, constant: 16),
            self.primaryActionButton.rightAnchor.constraint(equalTo: self.bodyLabel.rightAnchor),
            self.primaryActionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.primaryActionButton.heightAnchor.constraint(equalToConstant: 30),
        ])

        if self.subviews.contains(self.secondaryActionButton) {
            self.currentConstraints.append(contentsOf: [
                self.secondaryActionButton.centerYAnchor.constraint(equalTo: self.primaryActionButton.centerYAnchor),
                self.secondaryActionButton.rightAnchor.constraint(equalTo: self.primaryActionButton.leftAnchor, constant: -8),
                self.secondaryActionButton.heightAnchor.constraint(equalTo: self.primaryActionButton.heightAnchor),
            ])
        }

        // layout hack for iOS 12
        if #available(iOS 13.0, *) {} else {
            let superViewWidth = self.superview?.frame.width ?? 0
            let widthToLayoutView = self.calculateReadableContentGuideMargin(for: superViewWidth)
            let imageWidth = (superViewWidth - widthToLayoutView.left - widthToLayoutView.right) / 2
            let labelInsets = UIEdgeInsets(top: 0, left: imageWidth + 16, bottom: 0, right: 16)

            self.currentConstraints.append(contentsOf: [
                self.titleLabel.heightAnchor.constraint(equalToConstant: self.calculateLabelHeight(for: self.titleLabel, of: self.superview, with: labelInsets)),
                self.bodyLabel.heightAnchor.constraint(equalToConstant: self.calculateLabelHeight(for: self.bodyLabel, of: self.superview, with: labelInsets)),
                self.primaryActionButton.widthAnchor.constraint(equalToConstant: self.primaryActionButton.sizeThatFits(.zero).width),
            ])

            if self.subviews.contains(self.secondaryActionButton) {
                self.currentConstraints.append(self.secondaryActionButton.widthAnchor.constraint(equalToConstant: self.secondaryActionButton.sizeThatFits(.zero).width))
            }
        }

        NSLayoutConstraint.activate(self.currentConstraints)
    }

    private func applyCompactLayout() {
        self.clearConstraints()

        self.imageView.image = portraitImage

        self.currentConstraints.append(contentsOf: [
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 2/3),

            self.titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 16),
            self.titleLabel.leftAnchor.constraint(equalTo: self.imageView.leftAnchor, constant: 16),
            self.titleLabel.rightAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: -16),

            self.bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.bodyLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            self.bodyLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),

            self.primaryActionButton.topAnchor.constraint(equalTo: self.bodyLabel.bottomAnchor, constant: 16),
            self.primaryActionButton.rightAnchor.constraint(equalTo: self.bodyLabel.rightAnchor),
            self.primaryActionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.primaryActionButton.heightAnchor.constraint(equalToConstant: 30),
        ])

        if self.subviews.contains(self.secondaryActionButton) {
            self.currentConstraints.append(contentsOf: [
                self.secondaryActionButton.centerYAnchor.constraint(equalTo: self.primaryActionButton.centerYAnchor),
                self.secondaryActionButton.rightAnchor.constraint(equalTo: self.primaryActionButton.leftAnchor, constant: -8),
                self.secondaryActionButton.heightAnchor.constraint(equalTo: self.primaryActionButton.heightAnchor),
            ])
        }

        // layout hack for iOS 12.
        if #available(iOS 13.0, *) { } else {
            let labelInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            self.currentConstraints.append(contentsOf: [
                self.titleLabel.heightAnchor.constraint(equalToConstant: self.calculateLabelHeight(for: self.titleLabel, of: self.superview, with: labelInsets)),
                self.bodyLabel.heightAnchor.constraint(equalToConstant: self.calculateLabelHeight(for: self.bodyLabel, of: self.superview, with: labelInsets)),
                self.primaryActionButton.widthAnchor.constraint(equalToConstant: self.primaryActionButton.sizeThatFits(.zero).width),
            ])

            if self.subviews.contains(self.secondaryActionButton) {
                self.currentConstraints.append(self.secondaryActionButton.widthAnchor.constraint(equalToConstant: self.secondaryActionButton.sizeThatFits(.zero).width))
            }
        }

        NSLayoutConstraint.activate(self.currentConstraints)
    }

    private func clearConstraints() {
        NSLayoutConstraint.deactivate(self.currentConstraints)
        self.currentConstraints = []
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
#endif
