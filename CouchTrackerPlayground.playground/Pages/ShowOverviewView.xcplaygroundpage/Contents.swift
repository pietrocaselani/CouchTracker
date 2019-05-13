import PlaygroundSupport
import UIKit

import CouchTrackerApp
import CouchTrackerCore
import TraktSwift
import TMDBSwift
import TVDBSwift
import Kingfisher
import SnapKit
import RxSwift

class ExampleViewController: UIViewController {
    private var showView: ShowOverviewViewDemo {
        guard let v = self.view as? ShowOverviewViewDemo else {
            Swift.fatalError("self.view should be an instance of ShowOverviewViewDemo")
        }
        return v
    }

    override func loadView() {
        view = ShowOverviewViewDemo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        populateView()
    }

    private func populateView() {
        let posterLink = "https://image.tmdb.org/t/p/w780/ryJHo3A6KuzqidoBFHxzSpAvjeu.jpg"
        let backdropLink = "https://image.tmdb.org/t/p/w780/iEXdA9n9R7Cne2ZY8PQfAjiGyFP.jpg"

        let overview = "Two teenagers from very different backgrounds find themselves burdened and awakened to newly acquired superpowers.Two teenagers from very different backgrounds find themselves burdened and awakened to newly acquired superpowers.\nTwo teenagers from very different backgrounds find themselves burdened and awakened to newly acquired superpowers.\nTwo teenagers from very different backgrounds find themselves burdened and awakened to newly acquired superpowers.Two teenagers from very different backgrounds find themselves burdened and awakened to newly acquired superpowers.\nTwo teenagers from very different backgrounds find themselves burdened and awakened to newly acquired superpowers."

        showView.posterImageView.kf.setImage(with: posterLink.toURL)
        showView.backdropImageView.kf.setImage(with: backdropLink.toURL)

        self.title = "Marvel's Cloak & Dagger"
        showView.titleLabel.text = "Marvel's Cloak & Dagger"
        showView.overviewLabel.text = overview
        showView.networkLabel.text = "Freeform"
        showView.genresLabel.text = "Action, Adventure, Drama, Fantasy, Science-fiction"
        showView.releaseDateLabel.text = "08/06/2018"
        showView.statusLabel.text = "Returning series"

        showView.didTouchOnBackdrop = {
            print("Backdrop clicked")
        }

        showView.didTouchOnPoster = {
            print("Poster clicked")
        }
    }
}

public final class ShowOverviewViewDemo: CouchTrackerApp.View {
    public var didTouchOnPoster: (() -> Void)?
    public var didTouchOnBackdrop: (() -> Void)?

    // Public Views

    public let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    public let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnBackdrop))
        tap.numberOfTapsRequired = 1

        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = Colors.Text.primaryTextColor
        label.numberOfLines = 0
        return label
    }()

    public let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.secondaryTextColor
        label.numberOfLines = 0
        return label
    }()

    public let networkLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.secondaryTextColor
        label.numberOfLines = 0
        return label
    }()

    public let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.secondaryTextColor
        label.numberOfLines = 0
        return label
    }()

    public let genresLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.secondaryTextColor
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        return label
    }()

    public let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.secondaryTextColor
        return label
    }()

    // Private Views

    private let posterShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.75
        return view
    }()

    private lazy var contentStackView: ScrollableStackView = {
        let subviews = [backdropImageView, titleLabel, statusLabel, networkLabel,
                        overviewLabel, genresLabel, releaseDateLabel]
        let view = ScrollableStackView(subviews: subviews)

        let spacing: CGFloat = 20

        view.stackView.axis = .vertical
        view.stackView.alignment = .fill
        view.stackView.spacing = spacing
        view.stackView.distribution = .equalSpacing
        view.stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        view.stackView.isLayoutMarginsRelativeArrangement = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnPoster)))
        view.stackView.isUserInteractionEnabled = false

        return view
    }()

    // Setup

    public override func initialize() {
        addSubview(posterImageView)
        addSubview(posterShadowView)

        addSubview(contentStackView)
    }

    public override func installConstraints() {
        contentStackView.snp.makeConstraints { $0.size.equalToSuperview() }

        posterImageView.snp.makeConstraints { $0.size.equalToSuperview() }
        posterShadowView.snp.makeConstraints { $0.size.equalToSuperview() }
        backdropImageView.snp.makeConstraints {
            $0.height.equalTo(posterShadowView.snp.height).multipliedBy(0.27)
        }
    }

    @objc private func didTapOnPoster() {
        didTouchOnPoster?()
    }

    @objc private func didTapOnBackdrop() {
        didTouchOnBackdrop?()
    }
}

let viewController = ExampleViewController()

let (parent, _) = playgroundControllers(device: .phone3_5inch, orientation: .portrait, child: viewController)

//let (parent, _) = playgroundControllers(device: .phone3_5inch, orientation: .portrait, child: UINavigationController(rootViewController: viewController))

PlaygroundPage.current.liveView = parent
