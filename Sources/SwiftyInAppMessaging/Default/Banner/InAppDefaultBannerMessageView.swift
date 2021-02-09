//
//  InAppDefaultBannerMessageView.swift
//  SwiftyInAppMessaging
//
//  Created by 伊藤史 on 2021/01/19.
//

import FirebaseInAppMessaging
import Foundation
import UIKit

final class InAppDefaultBannerMessageView: UIView {
    let title: String
    let image: UIImage?
    let bodyText: String?
    let textColor: UIColor
    let eventDetector: MessageEventDetectable
    let actionURL: URL?

    private var hidingForAnimation: Bool
    private var hiddenBannerConstraint: NSLayoutConstraint?
    private var autoDimissTimer: Timer?

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var bodyLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var bannerImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false

        view.layer.cornerRadius = 8
        view.clipsToBounds = true

        return view
    }()

    init(title: String,
         image: UIImage?,
         bodyText: String?,
         backgroundColor: UIColor,
         textColor: UIColor,
         actionURL: URL?,
         eventDetector: MessageEventDetectable) {
        self.title = title
        self.image = image
        self.bodyText = bodyText
        self.textColor = textColor
        self.actionURL = actionURL
        self.eventDetector = eventDetector
        self.hidingForAnimation = true

        super.init(frame: .zero)

        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 1)

        self.addSubview(self.backgroundView)
        self.backgroundView.backgroundColor = backgroundColor
        self.backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        self.addSubview(self.bannerImage)
        self.bannerImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        self.bannerImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        self.bannerImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true

        if let image = image {
            self.bannerImage.image = image

            self.bannerImage.heightAnchor.constraint(equalTo: self.bannerImage.widthAnchor).isActive = true
        } else {
            self.bannerImage.widthAnchor.constraint(equalToConstant: 0).isActive = true
        }

        self.addSubview(self.titleLabel)
        self.titleLabel.text = title
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.bannerImage.rightAnchor, constant: 16).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.self.rightAnchor, constant: -4).isActive = true

        self.addSubview(self.bodyLabel)
        self.bodyLabel.text = bodyText
        self.bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4).isActive = true
        self.bodyLabel.leftAnchor.constraint(equalTo: self.bannerImage.rightAnchor, constant: 16).isActive = true
        self.bodyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        self.bodyLabel.rightAnchor.constraint(equalTo: self.self.rightAnchor, constant: -4).isActive = true

        self.heightAnchor.constraint(lessThanOrEqualToConstant: 60).isActive = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewDidPanned))

        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(panGesture)
    }

    @objc func viewDidTapped(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else {
            return
        }

        if let url = self.actionURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            self.hideBannerIfNeeded(completion: { [weak self] _ in
                self?.eventDetector.messageClicked(with: InAppMessagingAction(actionText: self?.title, actionURL: self?.actionURL))
            })
        }
    }

    @objc func viewDidPanned(recognizer: UIPanGestureRecognizer) {
        guard recognizer.state == .ended else {
            return
        }

        let velocity = recognizer.velocity(in: recognizer.view)
        if velocity.y < -10 {
            self.hideBannerIfNeeded(completion: { [weak self] _ in
                self?.eventDetector.messageDismissed(dismissType: .typeUserSwipe)
            })
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        self.leftAnchor.constraint(equalTo: self.superview!.leftAnchor, constant: 16).isActive = true
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32).isActive = true
        self.hiddenBannerConstraint = self.bottomAnchor.constraint(equalTo: self.superview!.topAnchor)
        self.hiddenBannerConstraint?.isActive = true
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.showBannerIfNeeded()
        self.autoDimissTimer = Timer.scheduledTimer(withTimeInterval: 12.0,
                                                    repeats: false,
                                                    block: { [weak self] _ in
                                                        self?.hideBannerIfNeeded(completion: { _ in
                                                            self?.eventDetector.messageDismissed(dismissType: .typeAuto)
                                                        })
                                                    })
    }

    private func showBannerIfNeeded(completion: ((Bool) -> Void)? = nil) {
        guard self.hidingForAnimation == true else {
            return
        }

        defer {
            self.hidingForAnimation = false
        }

        self.hiddenBannerConstraint?.isActive = false
        let bannerCenter = CGPoint(x: UIScreen.main.bounds.width / 2,
                                   y: self.frame.height / 2 + UIApplication.shared.statusBarFrame.size.height)

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.center = bannerCenter
            },
            completion: completion)
    }

    private func hideBannerIfNeeded(completion: ((Bool) -> Void)? = nil) {
        guard self.hidingForAnimation == false else {
            return
        }

        let bannerCenter = CGPoint(x: UIScreen.main.bounds.width / 2,
                                   y: -1 * (self.frame.height / 2 + UIApplication.shared.statusBarFrame.size.height))

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.curveLinear],
            animations: { [weak self] in
                self?.center = bannerCenter
            },
            completion: completion)
    }
}
