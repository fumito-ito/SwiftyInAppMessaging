//
//  InAppDefaultImageOnlyMessageView.swift
//
//
//  Created by 伊藤史 on 2022/02/19.
//
#if os(iOS) || os(tvOS)
    import FirebaseInAppMessaging
    import Foundation
    import UIKit

    protocol InAppDefaultImageOnlyViewDelegate: AnyObject {
        func imageDidTap()
    }

    final class InAppDefaultImageOnlyView: UIView {
        lazy var imageView: UIImageView = {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.contentMode = .scaleAspectFill
            view.clipsToBounds = true
            view.layer.cornerRadius = 8
            view.isUserInteractionEnabled = true

            let tapGesture = UITapGestureRecognizer(
                target: self, action: #selector(self.imageDidTap))
            view.addGestureRecognizer(tapGesture)

            return view
        }()

        weak var delegate: InAppDefaultImageOnlyViewDelegate?

        private var currentConstraints: [NSLayoutConstraint] = []

        init(image: UIImage?) {

            super.init(frame: .zero)

            self.imageView.image = image
            self.addSubview(self.imageView)

            self.backgroundColor = .clear
            self.translatesAutoresizingMaskIntoConstraints = false
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
#endif
