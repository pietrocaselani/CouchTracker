//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import UIKit

import CouchTrackerApp
import CouchTrackerCore
import TraktSwift
import TMDBSwift
import TVDBSwift
import Kingfisher
import Cartography
import RxSwift

final class DemoVC: UIViewController {
	private var showView: ShowEpisodeView2 {
		guard let loadingButtonView = self.view as? ShowEpisodeView2 else {
			preconditionFailure("self.view should be of type ShowEpisodeView2")
		}
		return loadingButtonView
	}

	override func loadView() {
		view = ShowEpisodeView2()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		vikings()

		showView.didTouchOnPreview = {
			print("Preview")
		}

		showView.didTouchOnWatch = {
			print("Eita!")
//			self.showView.watchButton.isLoading = true
//
//			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
//				self.showView.watchButton.isLoading = false
//			})
		}
	}

	private func vikings() {
		let posterLink = "https://image.tmdb.org/t/p/w342/mBDlsOhNOV1MkNii81aT14EYQ4S.jpg"
		let backdropLink = "https://image.tmdb.org/t/p/w780/A30ZqEoDbchvE7mCZcSp6TEwB1Q.jpg"

		showView.watchButton.button.setTitle("Add to history 123", for: .normal)

		showView.posterImageView.kf.setImage(with: URL(string: posterLink))
		showView.previewImageView.kf.setImage(with: URL(string: backdropLink))
		showView.titleLabel.text = "Vikings"
		showView.releaseDateLabel.text = "10/01/2011"
		showView.overviewLabel.text = "History sees the Vikings as a band of bloodthirsty pirates, raiding peaceful Christian monasteries... and it's true. The vikings took no prisoners, relished cruel retribution and prided themselves as fierce warriors. But their Prowess in battle is only the start of the story. Going on the trail of the real Vikings this series reveals an extraordinary story of a people who, from the brink of destruction, built an empire reaching around a qarter of the globe. Where did they come from? How did they really live?"
	}
}

public final class ShowEpisodeView2: CouchTrackerApp.View {
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

	public let watchButton: LoadingButton = {
		let loadingButton = LoadingButton()
		loadingButton.button.addTarget(self, action: #selector(didTapOnWatch), for: .touchUpInside)
		return loadingButton
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
													content.top == content.superview!.top
													content.leading == content.superview!.leading
													content.bottom == content.superview!.bottom
													content.trailing == content.superview!.trailing
		}
	}

	@objc private func didTapOnPreview() {
		print("didTouchOnPreview")
		didTouchOnPreview?()
	}

	@objc private func didTapOnWatch() {
		print("didTouchOnWatch")
		didTouchOnWatch?()
	}
}

public final class LoadingButton: CouchTrackerApp.View {
	public let button: UIButton = {
		UIButton()
	}()

	private let spinner: UIActivityIndicatorView = {
		UIActivityIndicatorView(style: .white)
	}()

	public var isLoading: Bool = false {
		didSet {
			update(loading: isLoading)
		}
	}

	private func update(loading: Bool) {
		if loading {
			spinner.startAnimating()
		} else {
			spinner.stopAnimating()
		}

		spinner.isHidden = !loading
		button.isHidden = loading
	}

	public override func initialize() {
		update(loading: false)

		addSubview(spinner)
		addSubview(button)
	}

	public override func installConstraints() {
		constrain(button, spinner) { button, spinner in
			button.center == button.superview!.center
			spinner.center == spinner.superview!.center
		}
	}
}

let vc = DemoVC()
PlaygroundPage.current.liveView = vc
