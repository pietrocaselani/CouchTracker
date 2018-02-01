import XCTest
import RxSwift
import RxTest
import TMDBSwift

final class ImageCachedRepositoryTest: XCTestCase {
	private let scheduler = TestSchedulers()

	func testImageCachedRepository_fetchMovieImages_withDefaultSizes() {
		//Given
		let repository = ImageCachedRepository(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock,
				cofigurationRepository: configurationRepositoryMock, schedulers: scheduler)
		let observer = scheduler.createObserver(ImagesEntity.self)

		//When
		_ = repository.fetchMovieImages(for: 550, posterSize: nil, backdropSize: nil).subscribe(observer)
		scheduler.start()

		//Then
		var link = "https:/image.tmdb.org/t/p/w300/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"
		let backdrop = ImageEntity(link: link, width: 1280, height: 720, iso6391: nil, aspectRatio: 1.77777777777778, voteAverage: 0, voteCount: 0)


		link = "https:/image.tmdb.org/t/p/w342/fpemzjF623QVTe98pCVlwwtFC5N.jpg"
		let poster = ImageEntity(link: link, width: 1200, height: 1800, iso6391: "en", aspectRatio: 0.666666666666667, voteAverage: 0, voteCount: 0)

		let images = ImagesEntity(identifier: 550, backdrops: [backdrop], posters: [poster], stills: [ImageEntity]())

		let expectedEvents = [next(1, images), completed(2)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testImageCachedRepository_fetchMovieImages_withSpecificSizes() {
		//Given
		let repository = ImageCachedRepository(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock,
				cofigurationRepository: configurationRepositoryMock, schedulers: scheduler)
		let observer = scheduler.createObserver(ImagesEntity.self)

		//When
		_ = repository.fetchMovieImages(for: 550, posterSize: .w92, backdropSize: .w1280).subscribe(observer)
		scheduler.start()

		//Then
		var link = "https:/image.tmdb.org/t/p/w1280/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"
		let backdrop = ImageEntity(link: link, width: 1280, height: 720, iso6391: nil, aspectRatio: 1.77777777777778, voteAverage: 0, voteCount: 0)


		link = "https:/image.tmdb.org/t/p/w92/fpemzjF623QVTe98pCVlwwtFC5N.jpg"
		let poster = ImageEntity(link: link, width: 1200, height: 1800, iso6391: "en", aspectRatio: 0.666666666666667, voteAverage: 0, voteCount: 0)

		let images = ImagesEntity(identifier: 550, backdrops: [backdrop], posters: [poster], stills: [ImageEntity]())

		let expectedEvents = [next(1, images), completed(2)]

		XCTAssertEqual(observer.events, expectedEvents)
	}
}
