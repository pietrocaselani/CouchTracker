import TraktSwift
import Foundation

struct EpisodeEntity: Hashable, EpisodeImageInput {
	let ids: EpisodeIds
	let showIds: ShowIds
	let title: String
	let overview: String?
	let number: Int
	let season: Int
	let firstAired: Date?
	let lastWatched: Date?

	var tvdb: Int {
		return ids.tvdb
	}

	var tmdb: Int? {
		return showIds.tmdb
	}

	var hashValue: Int {
		var hash = ids.hashValue ^ title.hashValue ^ number.hashValue ^ season.hashValue

		if let firstAiredHash = firstAired?.hashValue {
			hash ^= firstAiredHash
		}

		return hash
	}

	static func == (lhs: EpisodeEntity, rhs: EpisodeEntity) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
