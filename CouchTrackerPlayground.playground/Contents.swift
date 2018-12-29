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

public final class PosterCellDemo: CouchTrackerApp.CollectionViewCell {
	public let posterImageView: UIImageView = {
		UIImageView()
	}()

	public let titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 2
		label.backgroundColor = .red
		return label
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [posterImageView, titleLabel])

		stackView.axis = .vertical
		stackView.distribution = .equalSpacing

		return stackView
	}()

	public override func initialize() {
		contentView.addSubview(stackView)
	}

	public override func installConstraints() {
		constrain(stackView) { stack in
			stack.size == stack.superview!.size
		}
	}
}

public final class PosterCellViewControllerDemo: UICollectionViewController {
	public override func viewDidLoad() {
		super.viewDidLoad()

		collectionView.register(PosterCellDemo.self, forCellWithReuseIdentifier: "PosterCell")
	}

	public override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 100
	}

	public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCellDemo

		fantasticBeasts(cell)

		return cell
	}

	public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Item at \(indexPath.row)")
	}

	private func fantasticBeasts(_ cell: PosterCellDemo) {
		let posterURL = "https://image.tmdb.org/t/p/w154/uyJgTzAsp3Za2TaPiZt2yaKYRIR.jpg"

		cell.titleLabel.text = "Fantastic Beasts: The Crimes of Grindelwald"
		cell.posterImageView.kf.setImage(with: URL(string: posterURL))
	}
}

let layout = UICollectionViewFlowLayout()
layout.scrollDirection = .vertical
layout.itemSize = CGSize(width: 100, height: 180)
layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
layout.minimumInteritemSpacing = 0
layout.minimumLineSpacing = 10

let vc = PosterCellViewControllerDemo(collectionViewLayout: layout)

PlaygroundPage.current.liveView = vc
