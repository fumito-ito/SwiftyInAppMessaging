//
//  InAppDefaultModalMessageView.swift
//
//
//  Created by 伊藤史 on 2022/02/19.
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
            if self.actionButton.titleLabel?.text == nil
                || self.actionButton.titleLabel?.text?.isEmpty == true
            {
                return 0
            } else {
                return 16
            }
        }

        init(
            title: String,
            image: UIImage?,
            bodyText: String?,
            actionButton: ActionButton?,
            backgroundColor: UIColor,
            textColor: UIColor
        ) {

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
                    self.actionButton.setBackgroundImage(
                        buttonBackgroundColor.image(), for: .normal)
                }

                self.actionButton.addTarget(
                    self, action: #selector(buttonDidTap), for: .touchUpInside)
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
                self.titleLabel.leftAnchor.constraint(
                    equalTo: self.imageView.rightAnchor, constant: 16),
                self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),

                self.bodyLabel.topAnchor.constraint(
                    equalTo: self.titleLabel.bottomAnchor, constant: 16),
                self.bodyLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
                self.bodyLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),

                self.actionButton.topAnchor.constraint(
                    greaterThanOrEqualTo: self.bodyLabel.bottomAnchor, constant: 16),
                self.actionButton.centerXAnchor.constraint(equalTo: self.bodyLabel.centerXAnchor),
                self.actionButton.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor),
                self.actionButton.heightAnchor.constraint(equalToConstant: 30),
                self.actionButton.leftAnchor.constraint(
                    greaterThanOrEqualTo: self.imageView.rightAnchor, constant: 16),
                self.actionButton.rightAnchor.constraint(
                    greaterThanOrEqualTo: self.rightAnchor, constant: -16),
            ])

            if self.imageView.image != nil {
                self.currentConstrains.append(contentsOf: [
                    self.imageView.widthAnchor.constraint(
                        equalTo: self.widthAnchor, multiplier: 1 / 3),
                    self.imageView.heightAnchor.constraint(
                        equalTo: self.imageView.widthAnchor, multiplier: 1.0),
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

                self.imageView.topAnchor.constraint(
                    equalTo: self.titleLabel.bottomAnchor, constant: 16),
                self.imageView.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
                self.imageView.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),
            ])

            if self.imageView.image != nil {
                self.currentConstrains.append(
                    self.imageView.heightAnchor.constraint(
                        equalTo: self.imageView.widthAnchor, multiplier: 1.0))
            }

            self.currentConstrains.append(contentsOf: [
                self.bodyLabel.topAnchor.constraint(
                    equalTo: self.imageView.bottomAnchor, constant: self.bodyLabelPadding),
                self.bodyLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
                self.bodyLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),

                self.actionButton.topAnchor.constraint(
                    equalTo: self.bodyLabel.bottomAnchor, constant: self.actionButtonPadding),
                self.actionButton.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
                self.actionButton.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),
                self.actionButton.bottomAnchor.constraint(
                    equalTo: self.bottomAnchor, constant: -16),
                self.actionButton.heightAnchor.constraint(equalToConstant: 30),
            ])

            NSLayoutConstraint.activate(self.currentConstrains)
        }

        private func clearConstraints() {
            NSLayoutConstraint.deactivate(self.currentConstrains)
            self.currentConstrains = []
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
#endif
