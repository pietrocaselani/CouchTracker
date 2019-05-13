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
    private var typedView: MovieDetailsViewDemo {
        guard let v = self.view as? MovieDetailsViewDemo else {
            Swift.fatalError("self.view should be an instance of MovieDetailsViewDemo")
        }
        return v
    }

    override func loadView() {
        view = MovieDetailsViewDemo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        populateView()
    }

    private func populateView() {
        let posterLink = "https://image.tmdb.org/t/p/w780/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg"
        let backdropLink = "https://image.tmdb.org/t/p/w780/w2PMyoyLU22YvrGK3smVM9fW1jj.jpg"

        let title = "Captain Marvel"
        let tagline = "Higher. Further. Faster."
        let releaseDate = "08/03/2019"
        let buttonTitle = "Add to history"
        let watchedAt = "Unwatched"
        let genres = "Science-fiction, Action, Adventure, Superhero"
        let overview = "The story follows Carol Danvers as she becomes one of the universe’s most powerful heroes when Earth is caught in the middle of a galactic war between two alien races. Set in the 1990s, Captain Marvel is an all-new adventure from a previously unseen period in the history of the Marvel Cinematic Universe. The story follows Carol Danvers as she becomes one of the universe’s most powerful heroes when Earth is caught in the middle of a galactic war between two alien races. Set in the 1990s, Captain Marvel is an all-new adventure from a previously unseen period in the history of the Marvel Cinematic Universe. The story follows Carol Danvers as she becomes one of the universe’s most powerful heroes when Earth is caught in the middle of a galactic war between two alien races. Set in the 1990s, Captain Marvel is an all-new adventure from a previously unseen period in the history of the Marvel Cinematic Universe."

        typedView.titleLabel.text = title
        typedView.taglineLabel.text = tagline
        typedView.overviewLabel.text = overview
        typedView.genresLabel.setText(title: "Genres", detail: genres)
        typedView.releaseDateLabel.setText(title: "Release date", detail: releaseDate)
        typedView.posterImageView.kf.setImage(with: posterLink.toURL)
        typedView.backdropImageView.kf.setImage(with: backdropLink.toURL)
        typedView.watchButton.button.setTitle(buttonTitle, for: .normal)
        typedView.watchedAtLabel.setText(title: "Watched at", detail: watchedAt)

        typedView.didTouchOnWatch = {
            print("Watching!")
        }
    }
}

public final class MovieDetailsViewDemo: CouchTrackerApp.View {
    public var didTouchOnPoster: (() -> Void)?
    public var didTouchOnBackdrop: (() -> Void)?
    public var didTouchOnWatch: (() -> Void)?

    // Public Views

    public let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()

    public let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnBackdrop)))
        return imageView
    }()

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.titleBold
        label.textColor = Colors.Text.primaryTextColor
        label.numberOfLines = 0
        return label
    }()

    public let taglineLabel: UILabel = {
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

    public let genresLabel: TitleDetailLabels = {
        return TitleDetailLabels()
    }()

    public let releaseDateLabel: TitleDetailLabels = {
        return TitleDetailLabels()
    }()

    public let watchedAtLabel: TitleDetailLabels = {
        return TitleDetailLabels()
    }()

    public let watchButton: LoadingButton = {
        let button = LoadingButton()
        button.button.addTarget(self, action: #selector(didTapOnWatch), for: .touchUpInside)
        return button
    }()

    // Private Views

    private let scrollView: UIScrollView = {
        UIScrollView()
    }()

    private let posterShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.75
        return view
    }()

    private lazy var contentStackView: UIStackView = {
        let subviews = [backdropImageView, titleLabel, taglineLabel, overviewLabel,
                        genresLabel, releaseDateLabel, watchedAtLabel, watchButton]
        let stackView = UIStackView(arrangedSubviews: subviews)

        let spacing: CGFloat = 20

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = spacing
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnPoster)))

        return stackView
    }()

    // Setup

    public override func initialize() {
        addSubview(posterImageView)
        addSubview(posterShadowView)

        scrollView.addSubview(contentStackView)

        addSubview(scrollView)
    }

    public override func installConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.snp.edges)
            $0.width.equalTo(self.snp.width)
        }

        posterImageView.snp.makeConstraints { $0.size.equalToSuperview() }

        backdropImageView.snp.makeConstraints {
            $0.height.equalTo(self.snp.height).multipliedBy(0.27)
        }

        posterShadowView.snp.makeConstraints { $0.size.equalToSuperview() }
    }

    @objc private func didTapOnPoster() {
        didTouchOnPoster?()
    }

    @objc private func didTapOnBackdrop() {
        didTouchOnBackdrop?()
    }

    @objc private func didTapOnWatch() {
        didTouchOnWatch?()
    }
}

let viewController = ExampleViewController()
//let viewController = TitleDetailViewController()

//let (parent, child) = playgroundControllers(device: .phone3_5inch,
//                                            orientation: .portrait,
//                                            child: viewController)

//let (parent, _) = playgroundControllers(device: .phone3_5inch,
//                                        orientation: .portrait,
//                                        child: UINavigationController(rootViewController: viewController))

//child.view.backgroundColor = .white

//let frame = parent.view.bounds
PlaygroundPage.current.liveView = viewController
//parent.view.bounds = frame
