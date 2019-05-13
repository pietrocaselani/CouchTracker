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
    private var typedView: ShowEpisodeViewDemo {
        guard let v = self.view as? ShowEpisodeViewDemo else {
            Swift.fatalError("self.view should be an instance of ShowOverviewViewDemo")
        }
        return v
    }

    override func loadView() {
        view = ShowEpisodeViewDemo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        populateView()
    }

    private func populateView() {
        let posterLink = "https://image.tmdb.org/t/p/w780/ryJHo3A6KuzqidoBFHxzSpAvjeu.jpg"
        let backdropLink = "https://image.tmdb.org/t/p/w780/t8JWqTsWFXXrjsHrpm1s7QvBqMG.jpg"

        let title = "Restless Energy"
        let releaseDate = "05/04/2019"
        let seasonAndNumber = "2x01 (11)"
        let buttonTitle = "Add to history"
        let watchedAt = "Unwatched"
        let overview = "Now living very different lives, Tyrone and Tandy try to stay under the wire while still honing their powers. After coming to terms with their destiny, the two now find it difficult to just stand by and do nothing while bad things continue to happen throughout the city. Meanwhile, Brigid is struggling from her recovery.Now living very different lives, Tyrone and Tandy try to stay under the wire while still honing their powers. After coming to terms with their destiny, the two now find it difficult to just stand by and do nothing while bad things continue to happen throughout the city. Meanwhile, Brigid is struggling from her recovery."

        typedView.titleLabel.text = title
        typedView.overviewLabel.text = overview
        typedView.posterImageView.kf.setImage(with: posterLink.toURL)
        typedView.previewImageView.kf.setImage(with: backdropLink.toURL)
        typedView.releaseDateLabel.text = releaseDate
        typedView.seasonAndNumberLabel.text = seasonAndNumber
        typedView.watchButton.button.setTitle(buttonTitle, for: .normal)
        typedView.watchedAtLabel.text = watchedAt

        typedView.didTouchOnWatch = {
            print("Watching!")
        }

        typedView.didTouchOnPreview = {
            print("Preview clicked")
        }
    }
}

public final class ShowEpisodeViewDemo: CouchTrackerApp.View {
    public var didTouchOnPreview: (() -> Void)?
    public var didTouchOnWatch: (() -> Void)?

    // Public Views

    public let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    public let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnPreview)))
        imageView.clipsToBounds = true
        return imageView
    }()

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = Colors.Text.primaryTextColor
        label.numberOfLines = 0
        return label
    }()

    public let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.secondaryTextColor
        label.numberOfLines = 0
        return label
    }()

    public let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.secondaryTextColor
        return label
    }()

    public let watchedAtLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.secondaryTextColor
        return label
    }()

    public let seasonAndNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.secondaryTextColor
        return label
    }()

    public lazy var watchButton: LoadingButton = {
        let view = LoadingButton()
        view.button.addTarget(self, action: #selector(didTapOnWatch), for: .touchUpInside)
        return view
    }()

    // Private Views

    private let posterShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.75
        return view
    }()

    private lazy var contentStackView: ScrollableStackView = {
        let subviews = [previewImageView, titleLabel, overviewLabel,
                        releaseDateLabel, seasonAndNumberLabel, watchedAtLabel, watchButton]
        let view = ScrollableStackView(subviews: subviews)

        let spacing: CGFloat = 20

        view.stackView.axis = .vertical
        view.stackView.alignment = .fill
        view.stackView.spacing = spacing
        view.stackView.distribution = .equalSpacing
        view.stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        view.stackView.isLayoutMarginsRelativeArrangement = true

        return view
    }()

    // Setup

    public override func initialize() {
        backgroundColor = Colors.View.background

        addSubview(posterImageView)
        addSubview(posterShadowView)

        addSubview(contentStackView)
    }

    public override func installConstraints() {
        contentStackView.snp.makeConstraints { $0.size.equalToSuperview() }

        posterImageView.snp.makeConstraints { $0.size.equalToSuperview() }
        posterShadowView.snp.makeConstraints { $0.size.equalToSuperview() }
        previewImageView.snp.makeConstraints {
            $0.height.equalTo(posterShadowView.snp.height).multipliedBy(0.27)
        }
    }

    @objc private func didTapOnPreview() {
        didTouchOnPreview?()
    }

    @objc private func didTapOnWatch() {
        didTouchOnWatch?()
    }
}

let viewController = ExampleViewController()

let (parent, child) = playgroundControllers(device: .phone3_5inch,
                                            orientation: .portrait,
                                            child: viewController)

//let (parent, _) = playgroundControllers(device: .phone3_5inch,
//                                        orientation: .portrait,
//                                        child: UINavigationController(rootViewController: viewController))

//child.view.backgroundColor = .white

//let frame = parent.view.bounds
PlaygroundPage.current.liveView = parent
//parent.view.bounds = frame
