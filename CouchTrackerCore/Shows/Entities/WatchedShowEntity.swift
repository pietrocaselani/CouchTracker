import Foundation

public struct WatchedShowEntity: Hashable {
	public let show: ShowEntity
	public let aired: Int
	public let completed: Int
	public let nextEpisode: EpisodeEntity?
	public let lastWatched: Date?
	public let seasons: [WatchedSeasonEntity]

	public var hashValue: Int {
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

	public func newBuilder() -> WatchedShowEntityBuilder {
		return WatchedShowEntityBuilder.from(entity: self)
	}

	public static func == (lhs: WatchedShowEntity, rhs: WatchedShowEntity) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}

public final class WatchedShowEntityBuilder {
	public var show: ShowEntity?
	public var aired: Int?
	public var completed: Int?
	public var nextEpisode: EpisodeEntity?
	public var lastWatched: Date?
	public var seasons = [WatchedSeasonEntity]()

	private init(entity: WatchedShowEntity) {
		self.show = entity.show
		self.aired = entity.aired
		self.completed = entity.completed
		self.nextEpisode = entity.nextEpisode
		self.lastWatched = entity.lastWatched
	}

	public static func from(entity: WatchedShowEntity) -> WatchedShowEntityBuilder {
		return WatchedShowEntityBuilder(entity: entity)
	}

	public func build() -> WatchedShowEntity {
		guard let show = show else { fatalError("show can't be nil") }
		guard let aired = aired else { fatalError("aired can't be nil") }
		guard let completed = completed else { fatalError("completed can't be nil") }

		return WatchedShowEntity(show: show, aired: aired, completed: completed,
														nextEpisode: nextEpisode, lastWatched: lastWatched, seasons: seasons)
	}
}
