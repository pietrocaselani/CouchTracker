import TraktSwift

public protocol EpisodeImageInput {
	var tmdb: Int? { get }
	var tvdb: Int { get }
	var season: Int { get }
	var number: Int { get }
}
