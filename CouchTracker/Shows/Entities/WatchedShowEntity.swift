import Foundation

struct WatchedShowEntity: Hashable {
	let show: ShowEntity
	let aired: Int
	let completed: Int
	let nextEpisode: EpisodeEntity?
	let lastWatched: Date?
	let seasons: [WatchedSeasonEntity]

	var hashValue: Int {
		var hash = show.hashValue ^ aired.hashValue ^ completed.hashValue

		if let nextEpisodeHash = nextEpisode?.hashValue {
			hash ^= nextEpisodeHash
		}

		if let lastWatchedHash = lastWatched?.hashValue {
			hash ^= lastWatchedHash
		}

		seasons.forEach { hash ^= $0.hashValue }

		return hash
	}

	func newBuilder() -> WatchedShowEntityBuilder {
		return WatchedShowEntityBuilder.from(entity: self)
	}

	static func == (lhs: WatchedShowEntity, rhs: WatchedShowEntity) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}

final class WatchedShowEntityBuilder {
	var show: ShowEntity?
	var aired: Int?
	var completed: Int?
	var nextEpisode: EpisodeEntity?
	var lastWatched: Date?
	var seasons = [WatchedSeasonEntity]()

	private init(entity: WatchedShowEntity) {
		self.show = entity.show
		self.aired = entity.aired
		self.completed = entity.completed
		self.nextEpisode = entity.nextEpisode
		self.lastWatched = entity.lastWatched
	}

	static func from(entity: WatchedShowEntity) -> WatchedShowEntityBuilder {
		return WatchedShowEntityBuilder(entity: entity)
	}

	func build() -> WatchedShowEntity {
		guard let show = show else { fatalError("show can't be nil") }
		guard let aired = aired else { fatalError("aired can't be nil") }
		guard let completed = completed else { fatalError("completed can't be nil") }

		return WatchedShowEntity(show: show, aired: aired, completed: completed,
														nextEpisode: nextEpisode, lastWatched: lastWatched, seasons: seasons)
	}
}
