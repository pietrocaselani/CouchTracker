import TraktSwift

public final class ShowEntityMapper {
	private init() {}

	public static func entity(for show: Show, with genres: [Genre]? = nil) -> ShowEntity {
		return ShowEntity(ids: show.ids, title: show.title,
											overview: show.overview, network: show.network,
											genres: genres, status: show.status, firstAired: show.firstAired)
	}

	public static func entity(for trendingShow: TrendingShow, with genres: [Genre]? = nil) -> TrendingShowEntity {
		let show = entity(for: trendingShow.show, with: genres)
		return TrendingShowEntity(show: show)
	}
}
