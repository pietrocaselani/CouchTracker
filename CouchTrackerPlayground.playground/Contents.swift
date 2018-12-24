//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

import CouchTrackerApp
import CouchTrackerCore
import TraktSwift
import TMDBSwift
import TVDBSwift

let data = """
{
	"trakt": 193968,
	"slug": "aquaman-2018",
	"imdb": "tt1477834",
	"tmdb": 297802
}
""".data(using: .utf8)!

let movieIds = try! JSONDecoder().decode(MovieIds.self, from: data)

let viewController = MovieDetailsModule.setupModule(movieIds: movieIds)

PlaygroundPage.current.liveView = viewController as! UIViewController
