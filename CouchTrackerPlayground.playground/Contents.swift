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

class ViewController: UIViewController {
	private var movieView: MovieDetailsView {
		guard let movieView = self.view as? MovieDetailsView else {
			preconditionFailure("self.view should be of type MovieDetailsView")
		}
		return movieView
	}

	override func loadView() {
		view = MovieDetailsView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let posterLink = "https://image.tmdb.org/t/p/w342/uyJgTzAsp3Za2TaPiZt2yaKYRIR.jpg"
		let backdropLink = "https://image.tmdb.org/t/p/w780//wDN3FIcQQ1HI7mz1OOKYHSQtaiE.jpg"

		movieView.backdropImageView.kf.setImage(with: URL(string: backdropLink))
		movieView.posterImageView.kf.setImage(with: URL(string: posterLink))
		movieView.titleLabel.text = "Fantastic Beasts: The Crimes of Grindelwald"
		movieView.taglineLabel.text = "Fate of One. Future of All."
		movieView.overviewLabel.text = "Gellert Grindelwald has escaped imprisonment and has begun gathering followers to his cause—elevating wizards above all non-magical beings. The only one capable of putting a stop to him is the wizard he once called his closest friend, Albus Dumbledore. However, Dumbledore will need to seek help from the wizard who had thwarted Grindelwald once before, his former student Newt Scamander, who agrees to help, unaware of the dangers that lie ahead. Lines are drawn as love and loyalty are tested, even among the truest friends and family, in an increasingly divided wizarding world."
		movieView.releaseDateLabel.text = "2018-12-21"
		movieView.watchedAtLabel.text = "2018-12-22"
		movieView.genresLabel.text = "Fantasy | Family | Adventure"

		movieView.watchButton.setTitle("Adicionar ao histórico", for: .normal)

		movieView.didTouchOnWatch = {
			print("Watched!!")
		}

		movieView.didTouchOnBackdrop = {
			print("Backdrop!!")
		}

		movieView.didTouchOnPoster = {
			print("Poster!!")
		}
	}
}

PlaygroundPage.current.liveView = ViewController()
