import TraktSwift
import Foundation

public struct MovieEntity: Hashable {
	public let ids: MovieIds
	public let title: String?
	public let genres: [Genre]?
	public let tagline: String?
	public let overview: String?
	public let releaseDate: Date?
	public let watchedAt: Date?

	public var hashValue: Int {
		var hash = ids.hashValue

		if let titleHash = title?.hashValue {
			hash = hash ^ titleHash
		}

		if let taglineHash = tagline?.hashValue {
			hash = hash ^ taglineHash
		}

		if let overviewHash = overview?.hashValue {
			hash = hash ^ overviewHash
		}

		if let releaseDateHash = releaseDate?.hashValue {
			hash = hash ^ releaseDateHash
		}

		if let watchedAtHash = watchedAt?.hashValue {
			hash = hash ^ watchedAtHash
		}

		genres?.forEach { hash = hash ^ $0.hashValue }

		return hash
	}

	public static func == (lhs: MovieEntity, rhs: MovieEntity) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
}
