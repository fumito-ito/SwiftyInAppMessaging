//
//  InAppDefaultBannerMessageView.swift
//  SwiftyInAppMessaging
//
//  Created by 伊藤史 on 2021/01/19.
//
#if os(iOS) || os(tvOS)
import FirebaseInAppMessaging
import Foundation
import UIKit

protocol InAppDefaultBannerMessageViewDelegate: AnyObject {
    func bannerDidTapped(_: InAppDefaultBannerMessageView)
    func bannerDidPanned(_: InAppDefaultBannerMessageView)
}

final class InAppDefaultBannerMessageView: UIView {
    let title: String
    let image: UIImage?
    let bodyText: String?
    let textColor: UIColor

    private var hiddenBannerConstraint: NSLayoutConstraint?

    weak var delegate: InAppDefaultBannerMessageViewDelegate?

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

    lazy var bannerImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true

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
         textColor: UIColor) {
        self.title = title
        self.image = image
        self.bodyText = bodyText
        self.textColor = textColor

        super.init(frame: .zero)

        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)

        self.addSubview(self.backgroundView)
        self.backgroundView.backgroundColor = backgroundColor
        NSLayoutConstraint.activate([
            self.backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        self.addSubview(self.bannerImage)
        NSLayoutConstraint.activate([
            self.bannerImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            self.bannerImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
            self.bannerImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
        ])

        if let image = image {
            self.bannerImage.image = image

            self.bannerImage.heightAnchor.constraint(equalTo: self.bannerImage.widthAnchor, multiplier: 1.0).isActive = true
        } else {
            self.bannerImage.widthAnchor.constraint(equalToConstant: 0).isActive = true
        }

        self.addSubview(self.titleLabel)
        self.titleLabel.text = title
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            self.titleLabel.leftAnchor.constraint(equalTo: self.bannerImage.rightAnchor, constant: 16),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
        ])

        self.addSubview(self.bodyLabel)
        self.bodyLabel.text = bodyText
        NSLayoutConstraint.activate([
            self.bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4),
            self.bodyLabel.leftAnchor.constraint(equalTo: self.bannerImage.rightAnchor, constant: 16),
            self.bodyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            self.bodyLabel.rightAnchor.constraint(equalTo: self.self.rightAnchor, constant: -4),

            self.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
        ])


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewDidPanned))

        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(panGesture)
    }

    @objc func viewDidTapped(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else {
            return
        }

        self.delegate?.bannerDidTapped(self)
    }

    @objc func viewDidPanned(recognizer: UIPanGestureRecognizer) {
        guard recognizer.state == .ended else {
            return
        }

        let velocity = recognizer.velocity(in: recognizer.view)
        guard velocity.y < -10 else {
            return
        }

        self.delegate?.bannerDidPanned(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showBanner(for view: UIView, completion: ((Bool) -> Void)? = nil) {
        let statusBarHeight: CGFloat
        #if os(tvOS)
        statusBarHeight = 0
        #else
        statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        #endif

        let bannerCenter = CGPoint(x: view.center.x,
                                   y: self.frame.height / 2 + statusBarHeight)

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.center = bannerCenter
            },
            completion: completion)
    }

    func hideBanner(for view: UIView, completion: ((Bool) -> Void)? = nil) {
        let statusBarHeight: CGFloat
        #if os(tvOS)
        statusBarHeight = 0
        #else
        statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        #endif

        let bannerCenter = CGPoint(x: view.center.x,
                                   y: -1 * (self.frame.height / 2 + statusBarHeight))

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.curveLinear],
            animations: { [weak self] in
                self?.center = bannerCenter
            },
            completion: completion)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}

final class InAppDefaultBannerMessageViewController: UIViewController {
    let bannerView: InAppDefaultBannerMessageView

    let eventDetector: MessageEventDetectable

    let actionURL: URL?
    let bannerTitle: String
    private(set) var autoDismissTimer: Timer?
    private(set) var hideBannerConstraint: NSLayoutConstraint?
    private(set) var showBannerConstraint: NSLayoutConstraint?

    init(title: String,
         image: UIImage?,
         bodyText: String?,
         backgroundColor: UIColor,
         textColor: UIColor,
         actionURL: URL?,
         eventDetector: MessageEventDetectable) {

        self.bannerView = InAppDefaultBannerMessageView(title: title,
                                                        image: image,
                                                        bodyText: bodyText,
                                                        backgroundColor: backgroundColor,
                                                        textColor: textColor)

        self.eventDetector = eventDetector
        self.actionURL = actionURL
        self.bannerTitle = title

        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = .overFullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.bannerView)
        self.applyLayout()

        self.bannerView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showBanner(completion: { [weak self] completed in
            guard let `self` = self, completed else {
                return
            }

            self.autoDismissTimer = Timer.scheduledTimer(timeInterval: TimeInterval(3.0),
                                           target: self,
                                           selector: #selector(self.dismissByTimer),
                                           userInfo: nil,
                                           repeats: false)
        })
    }

    func applyLayout() {
        let hideBannerConstraint = self.bannerView.bottomAnchor.constraint(equalTo: self.view.topAnchor)
        self.hideBannerConstraint = hideBannerConstraint

        let statusBarHeight: CGFloat
        #if os(tvOS)
        statusBarHeight = 0
        #else
        statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        #endif

        self.showBannerConstraint = self.bannerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusBarHeight)

        NSLayoutConstraint.activate([
            self.bannerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.bannerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            hideBannerConstraint,
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func dismissByTimer() {
        self.hideBanner(completion: { [weak self] _ in
            self?.eventDetector.messageDismissed(dismissType: .typeAuto)
        })
    }

    @objc private func hideBanner(completion: ((Bool) -> Void)? = nil) {
        self.bannerView.hideBanner(for: self.view, completion: { [weak self] completed in
            self?.showBannerConstraint?.isActive = false
            self?.hideBannerConstraint?.isActive = true
            completion?(completed)
        })
    }

    private func showBanner(completion: ((Bool) -> Void)? = nil) {
        self.bannerView.showBanner(for: self.view, completion: { [weak self] completed in
            self?.hideBannerConstraint?.isActive = false
            self?.showBannerConstraint?.isActive = true
            completion?(completed)
        })
    }
}

extension InAppDefaultBannerMessageViewController: InAppDefaultBannerMessageViewDelegate {
    func bannerDidTapped(_: InAppDefaultBannerMessageView) {
        if let url = self.actionURL, UIApplication.shared.canOpenURL(url) {
            self.hideBanner(completion: { [weak self] _ in
                let action = InAppMessagingAction(actionText: self?.title, actionURL: self?.actionURL)
                self?.eventDetector.messageClicked(with: action)
            })

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func bannerDidPanned(_: InAppDefaultBannerMessageView) {
        self.hideBanner(completion: { [weak self] _ in
            self?.eventDetector.messageDismissed(dismissType: .typeUserSwipe)
        })
    }
}
#endif
