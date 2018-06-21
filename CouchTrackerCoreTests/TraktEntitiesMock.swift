import TraktSwift

final class TraktEntitiesMock {
	static func decodeTraktJSON<T: Codable>(with name: String) -> T {
		let data = traktDataForJSON(with: name)
		return try! jsonDecoder.decode(T.self, from: data)
	}

	static func decodeTraktJSONArray<T: Codable>(with name: String) -> [T] {
		let data = traktDataForJSON(with: name)
		return try! jsonDecoder.decode([T].self, from: data)
	}

	static func traktDataForJSON(with name: String) -> Data {
		let resourcesPath = Bundle(for: Trakt.self).bundlePath

		let bundle = findBundleUsing(resourcesPath: resourcesPath)

		let url = bundle.url(forResource: name, withExtension: "json")

		guard let fileURL = url, let data = try? Data(contentsOf: fileURL) else {
			return Data()
		}

		return data
	}

	static var jsonDecoder: JSONDecoder {
		return JSONDecoder()
	}

	static func createSearchResultsMock() -> [SearchResult] {
		let data = Search.textQuery(types: [.movie], query: "Tron", page: 0, limit: 100).sampleData

		return try! jsonDecoder.decode([SearchResult].self, from: data)
	}

	static func createMoviesGenresMock() -> [Genre] {
		return try! jsonDecoder.decode([Genre].self, from: Genres.list(.movies).sampleData)
	}

	static func createShowsGenresMock() -> [Genre] {
		return try! jsonDecoder.decode([Genre].self, from: Genres.list(.shows).sampleData)
	}

	static func createTrendingShowsMock() -> [TrendingShow] {
		return try! jsonDecoder.decode([TrendingShow].self, from: Shows.trending(page: 0, limit: 10, extended: .full).sampleData)
	}

	static func createTrendingMoviesMock() -> [TrendingMovie] {
		return try! jsonDecoder.decode([TrendingMovie].self, from: Movies.trending(page: 0, limit: 10, extended: .full).sampleData)
	}

	static func createMockMovies() -> [TrendingMovie] {
		return try! jsonDecoder.decode([TrendingMovie].self, from: Movies.trending(page: 0, limit: 50, extended: .full).sampleData)
	}

	static func createMovieMock(for movieId: String) -> Movie {
		let movies = createMockMovies()

		let trendingMovie = movies.first { $0.movie.ids.slug == movieId }

		return trendingMovie?.movie ?? createMovieDetailsMock(for: movieId)
	}

	static func createMovieDetailsMock(for movieId: String) -> Movie {
		return try! jsonDecoder.decode(Movie.self, from: Movies.summary(movieId: movieId, extended: .full).sampleData)
	}

	static func createUnwatchedMovieDetailsMock() -> Movie {
		let data = traktDataForJSON(with: "trakt_unwatched_movie_summary")
		return try! jsonDecoder.decode(Movie.self, from: data)
	}

	static func createMovieDetailsMock() -> Movie {
		return createMovieDetailsMock(for: "tron-legacy-2010")
	}

	static func createTraktShowDetails() -> Show {
		return try! jsonDecoder.decode(Show.self, from: Shows.summary(showId: "game-of-thrones", extended: .full).sampleData)
	}

	static func createUserSettingsMock() -> Settings {
		return try! jsonDecoder.decode(Settings.self, from: Users.settings.sampleData)
	}

	private static func findBundleUsing(resourcesPath: String) -> Bundle {
		var path = "/../"

		var bundle: Bundle? = nil
		var attempt = 0

		repeat {
			bundle = Bundle(path: resourcesPath.appending("\(path)TraktTestsResources.bundle"))
			path.append("../")
			attempt += 1
		} while bundle == nil && attempt < 5

		return bundle!
	}
}
