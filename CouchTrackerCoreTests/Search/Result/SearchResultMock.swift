import TraktSwift

extension SearchResult {

	static func mock(type: SearchType = .show,
																		score: Double? = 2.3,
																		movie: Movie? = TraktEntitiesMock.createMovieDetailsMock(),
																		show: Show? = TraktEntitiesMock.createTraktShowDetails()) -> SearchResult {
		let jsonScore: Any = score.map { "\($0)" } ?? "null"

		let typeJSON: String

		if let showJSON = self.showJSON(show) {
			typeJSON = showJSON
		} else if let movieJSON = self.movieJSON(movie) {
			typeJSON = movieJSON
		} else {
			Swift.fatalError("Can't create JSON")
		}

		let json = """
						{
								"type": "\(type.rawValue)",
								"score": \(jsonScore),
								\(typeJSON)
						}
			"""

		guard let data = json.data(using: .utf8) else {
			Swift.fatalError("Can't create data from JSON string")
		}

		return try! JSONDecoder().decode(SearchResult.self, from: data)
	}

	private static func movieJSON(_ movie: Movie?) -> String? {
		guard let movie = movie else { return nil }

		let jsonTitle = movie.title.map { "\"\($0)\"" } ?? "null"
		let jsonYear: Any = movie.year ?? "null"
		let jsonImdb = movie.ids.imdb.map { "\"\($0)\"" } ?? "null"
		let jsonTmdb: Any = movie.ids.tmdb ?? "null"

		return """
						"movie": {
							"title": \(jsonTitle),
							"year": \(jsonYear),
							"ids": {
								"trakt": \(movie.ids.trakt),
								"slug": "\(movie.ids.slug)",
								"imdb": \(jsonImdb),
								"tmdb": \(jsonTmdb),
							}
						}
		"""
	}

	private static func showJSON(_ show: Show?) -> String? {
		guard let show = show else { return nil }

		let jsonTitle = show.title.map { "\"\($0)\"" } ?? "null"
		let jsonYear: Any = show.year ?? "null"
		let jsonImdb = show.ids.imdb.map { "\"\($0)\"" } ?? "null"
		let jsonTvrage: Any = show.ids.tvrage ?? "null"
		let jsonTmdb: Any = show.ids.tmdb ?? "null"

		return """
						"show": {
								"title": \(jsonTitle),
								"year": \(jsonYear),
								"ids": {
										"trakt": \(show.ids.trakt),
										"slug": "\(show.ids.slug)",
										"tvdb": \(show.ids.tvdb),
										"imdb": \(jsonImdb),
										"tvrage": \(jsonTvrage),
										"tmdb": \(jsonTmdb)
								}
						}
						"""
	}
}
