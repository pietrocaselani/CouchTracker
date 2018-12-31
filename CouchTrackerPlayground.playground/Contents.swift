//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

import CouchTrackerApp
import CouchTrackerCore
import TraktSwift
import TMDBSwift
import TVDBSwift
import Kingfisher
import Cartography

public class ShowEpisodeViewDemo: CouchTrackerApp.View {
	public var didTouchOnPreview: (() -> Void)?
	public var didTouchOnWatch: (() -> Void)?

	// Public Views

	public let posterImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = UIView.ContentMode.scaleAspectFill
		return imageView
	}()

	public let previewImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = UIView.ContentMode.scaleAspectFill
		imageView.isUserInteractionEnabled = true
		imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnPreview)))
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

	public let watchButton: UIButton = {
		let button = UIButton()
		button.addTarget(self, action: #selector(didTapOnWatch), for: .touchUpInside)
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
		let subviews = [previewImageView, titleLabel, overviewLabel,
																		releaseDateLabel, watchedAtLabel, watchButton]
		let stackView = UIStackView(arrangedSubviews: subviews)

		let spacing: CGFloat = 20

		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = spacing
		stackView.distribution = .equalSpacing
		stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		stackView.isLayoutMarginsRelativeArrangement = true

		return stackView
	}()

	// Setup

	public override func initialize() {
		super.initialize()

		backgroundColor = Colors.View.background

		addSubview(posterImageView)
		addSubview(posterShadowView)

		scrollView.addSubview(contentStackView)

		addSubview(scrollView)
	}

	public override func installConstraints() {
		super.installConstraints()

		constrain(scrollView,
												contentStackView,
												posterImageView,
												previewImageView,
												posterShadowView) { scroll, content, poster, preview, shadow in
													scroll.size == scroll.superview!.size

													poster.size == poster.superview!.size
													shadow.size == shadow.superview!.size

													preview.height == scroll.superview!.height * 0.27

													content.width == content.superview!.width
													content.top == content.superview!.top + 20
													content.leading == content.superview!.leading
													content.bottom == content.superview!.bottom
													content.trailing == content.superview!.trailing
		}
	}

	@objc private func didTapOnPreview() {
		didTouchOnPreview?()
	}

	@objc private func didTapOnWatch() {
		didTouchOnWatch?()
	}
}

final class ViewController: UIViewController {
	private var episodeView: ShowEpisodeView {
		guard let episodeView = self.view as? ShowEpisodeView else {
			preconditionFailure("self.view should be of type ShowEpisodeView")
		}
		return episodeView
	}

	override func loadView() {
		view = ShowEpisodeView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		episodeView.didTouchOnPreview = {
			print("Preview!!")
		}

		episodeView.didTouchOnWatch = {
			print("Watch!")
		}

		yourFuneral()
	}

	private func yourFuneral() {
		let episode = decodeJSON(named: "Your Funeral", of: WatchedEpisodeEntity.self)

		let previewLink = "https://image.tmdb.org/t/p/w500/57haJfMOxlkBSFQSK2sjGu7UcA9.jpg"
		let posterLink = "https://image.tmdb.org/t/p/w780/pnUh2RawzYaSU8IjG61MT0AMRyf.jpg"

		let formatter = DateFormatter()
		formatter.dateStyle = .long

		let releaseDate: String

		if let firstAired = episode.episode.firstAired {
			releaseDate = formatter.string(from: firstAired)
		} else {
			releaseDate = "Not released"
		}

		episodeView.posterImageView.kf.setImage(with: posterLink.toURL)
		episodeView.previewImageView.kf.setImage(with: previewLink.toURL)
		episodeView.titleLabel.text = episode.episode.title
		episodeView.overviewLabel.text = episode.episode.overview ?? "No overview"
		episodeView.releaseDateLabel.text = releaseDate
		episodeView.watchedAtLabel.text = episode.lastWatched?.shortString() ?? "Unwatched"

		let buttonTitle = episode.lastWatched == nil ? "Adicionar ao histórico" : "Remover do histórico"

		episodeView.watchButton.setTitle(buttonTitle, for: .normal)
	}
}

func decodeJSON<T: Decodable>(named: String, of type: T.Type) -> T {
	let path = Bundle.main.path(forResource: named, ofType: "json")!
	let data = try! Data(contentsOf: URL(fileURLWithPath: path))
	return try! JSONDecoder().decode(type, from: data)
}


let vc = ViewController()
//let vc = ColorsViewController()
PlaygroundPage.current.liveView = vc
