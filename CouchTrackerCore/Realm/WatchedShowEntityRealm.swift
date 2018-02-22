import RealmSwift

final class WatchedShowEntityRealm: Object {
	@objc private dynamic var identifier = ""
	@objc private dynamic var backingShow: ShowEntityRealm?
	@objc dynamic var aired = -1
	@objc dynamic var completed = -1
	@objc dynamic var nextEpisode: EpisodeEntityRealm?
	@objc dynamic var lastWatched: Date?
	let seasons = List<WatchedSeasonEntityRealm>()

	var show: ShowEntityRealm? {
		get {
			return backingShow
		}
		set {
			backingShow = newValue
			if let traktId = newValue?.ids?.trakt {
				let typeName = String(describing: WatchedShowEntity.self)
				identifier = "\(typeName)-\(traktId)"
			}
		}
	}

	override static func primaryKey() -> String? {
		return "identifier"
	}

	override static func ignoredProperties() -> [String] {
		return ["show"]
	}

	override func isEqual(_ object: Any?) -> Bool {
		guard let entity = object as? WatchedShowEntityRealm else { return false }

		return self == entity
	}

	static func == (lhs: WatchedShowEntityRealm, rhs: WatchedShowEntityRealm) -> Bool {
		return lhs.identifier == rhs.identifier &&
			lhs.backingShow == rhs.backingShow &&
			lhs.aired == rhs.aired &&
			lhs.completed == rhs.completed &&
			lhs.nextEpisode == rhs.nextEpisode &&
			lhs.lastWatched == rhs.lastWatched
	}

	func toEntity() -> WatchedShowEntity {
		guard let show = self.show?.toEntity() else {
			Swift.fatalError("How show is not present on EpisodeEntityRealm?!")
		}

		return WatchedShowEntity(show: show,
														aired: self.aired,
														completed: self.completed,
														nextEpisode: self.nextEpisode?.toEntity(),
														lastWatched: self.lastWatched,
														seasons: self.seasons.map { $0.toEntity() })
	}
}

extension WatchedShowEntity {
	func toRealm() -> WatchedShowEntityRealm {
		let entity = WatchedShowEntityRealm()

		entity.show = self.show.toRealm()
		entity.aired = self.aired
		entity.completed = self.completed
		entity.nextEpisode = self.nextEpisode?.toRealm()
		entity.lastWatched = self.lastWatched
		entity.seasons.append(objectsIn: self.seasons.map { $0.toRealm() })

		return entity
	}
}
