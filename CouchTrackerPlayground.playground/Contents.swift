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
import RxSwift

final class ViewControllerDemo: UIViewController {
	private var showView: ShowEpisodeView {
		return self.view as! ShowEpisodeView
	}

	override func loadView() {
		view = ShowEpisodeView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		bug1()
	}

	private func bug1() {
		let posterLink = "https://image.tmdb.org/t/p/w780/pnUh2RawzYaSU8IjG61MT0AMRyf.jpg"
		let previewLink = "https://image.tmdb.org/t/p/w500/jFtZF4cdm3yVaL5nNpEFq2hacGl.jpg"

		showView.posterImageView.kf.setImage(with: posterLink.toURL)
		showView.previewImageView.kf.setImage(with: previewLink.toURL)

		showView.titleLabel.text = "It Was the Worst Day of My Life"
		showView.overviewLabel.text = "After Annalise chooses Gabriel as her second chair, the unexpected duo puts all of their efforts into Nate Sr.’s murder re-trial as they try to convince a jury to grant an insanity plea. Meanwhile, Bonnie struggles to rebound after a dark part of her past resurfaces."

	}
}

//let vc = ColorsViewController()
let vc = ViewControllerDemo()
PlaygroundPage.current.liveView = vc
