import TraktSwift

struct SeasonEntity: Hashable {
	let ids: SeasonIds
	let showIds: ShowIds
	let number: Int
	let episodeCount: Int?
	let airedCount: Int?
	let overview: String?
	let rating: Double?
	let votes: Int?
	let episodes: [EpisodeEntity]

	var hashValue: Int {
		var hash = ids.hashValue
		hash ^= showIds.hashValue
		hash ^= number.hashValue

		episodeCount.run { hash ^= $0.hashValue }
		airedCount.run { hash ^= $0.hashValue }
		overview.run { hash ^= $0.hashValue }
		rating.run { hash ^= $0.hashValue }
		votes.run { hash ^= $0.hashValue }
	}

	static func == (lhs: SeasonEntity, rhs: SeasonEntity) -> Bool {
		fatalError("== has not been implemented")
	}
}
